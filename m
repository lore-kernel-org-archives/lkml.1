Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYLLKpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYLLKpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYLLKou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:44:50 -0500
Received: from www.tglx.de ([62.245.132.106]:54861 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbYLLKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:44:49 -0500
Date: Fri, 12 Dec 2008 11:44:21 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] uio: make uio_info's name and version const
Message-ID: <20081212104420.GA3084@local>
References: <20081212163041.7bc16261.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212163041.7bc16261.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 04:30:41PM +1100, Stephen Rothwell wrote:
> These are only ever assigned constant strings and never modified.

Hi Stephen,
that's correct, thanks for pointing this out.

@Greg: Stephen's patch will only apply with some fuzz since you've
accepted my portio patches in your queue. Below there's a version
that should apply cleanly.

> 
> This was noticed because Wolfram Sang needed to cast the result of
> of_get_property() in order to assign it to the name field of a struct
> uio_info.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  Documentation/DocBook/uio-howto.tmpl |    4 ++--
>  include/linux/uio_driver.h           |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> Tested by compiling all the uio drivers available on x86.  The others
> (all in arch sh) only ever assign constant string literals to these
> fields.
> 
> [Resent with properly quoted recipient addresses]
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index df87d1b..21ba47e 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -339,12 +339,12 @@ offset = N * getpagesize();
>  
>  <itemizedlist>
>  <listitem><para>
> -<varname>char *name</varname>: Required. The name of your driver as
> +<varname>const char *name</varname>: Required. The name of your driver as
>  it will appear in sysfs. I recommend using the name of your module for this.
>  </para></listitem>
>  
>  <listitem><para>
> -<varname>char *version</varname>: Required. This string appears in
> +<varname>const char *version</varname>: Required. This string appears in
>  <filename>/sys/class/uio/uioX/version</filename>.
>  </para></listitem>
>  
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index cdf338d..b5f23b1 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -57,8 +57,8 @@ struct uio_device;
>   */
>  struct uio_info {
>  	struct uio_device	*uio_dev;
> -	char			*name;
> -	char			*version;
> +	const char		*name;
> +	const char		*version;
>  	struct uio_mem		mem[MAX_UIO_MAPS];
>  	long			irq;
>  	unsigned long		irq_flags;
> -- 
> 1.6.0.5

--------->8-----begin rebased version------------------------------------

These are only ever assigned constant strings and never modified.

This was noticed because Wolfram Sang needed to cast the result of
of_get_property() in order to assign it to the name field of a struct
uio_info.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 Documentation/DocBook/uio-howto.tmpl |    4 ++--
 include/linux/uio_driver.h           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Tested by compiling all the uio drivers available on x86.  The others
(all in arch sh) only ever assign constant string literals to these
fields.

Index: linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl
===================================================================
--- linux-2.6.28-rc.orig/Documentation/DocBook/uio-howto.tmpl	2008-12-06 02:08:16.000000000 +0100
+++ linux-2.6.28-rc/Documentation/DocBook/uio-howto.tmpl	2008-12-12 11:28:37.000000000 +0100
@@ -393,12 +393,12 @@
 
 <itemizedlist>
 <listitem><para>
-<varname>char *name</varname>: Required. The name of your driver as
+<varname>const char *name</varname>: Required. The name of your driver as
 it will appear in sysfs. I recommend using the name of your module for this.
 </para></listitem>
 
 <listitem><para>
-<varname>char *version</varname>: Required. This string appears in
+<varname>const char *version</varname>: Required. This string appears in
 <filename>/sys/class/uio/uioX/version</filename>.
 </para></listitem>
 
Index: linux-2.6.28-rc/include/linux/uio_driver.h
===================================================================
--- linux-2.6.28-rc.orig/include/linux/uio_driver.h	2008-12-06 02:07:21.000000000 +0100
+++ linux-2.6.28-rc/include/linux/uio_driver.h	2008-12-12 11:28:37.000000000 +0100
@@ -76,8 +76,8 @@
  */
 struct uio_info {
 	struct uio_device	*uio_dev;
-	char			*name;
-	char			*version;
+	const char		*name;
+	const char		*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
 	struct uio_port		port[MAX_UIO_PORT_REGIONS];
 	long			irq;


