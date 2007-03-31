Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXCaBV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXCaBV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXCaBV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:21:26 -0400
Received: from smtp008.mail.ukl.yahoo.com ([217.12.11.62]:43548 "HELO
	smtp008.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932809AbXCaBVZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:21:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aonP7ILVHdFujCe84AMnLD3dl9GDPE9/0hgCjcaeix6PENZRY2ioskwTm9VcJSHNgX03nUxTS7cr4NighMHGHIeRh9y9f3FFLPM39Hk+z49lwyKQMoPE6Xk0ptYFeuu7jlD8xGY5a8fEMOBp8OKHCk5D0LKbS4hhY3BgilVPzSY=  ;
X-YMail-OSG: 0W3o1hkVM1nyhQihrja51Vi4CEvXEU_Nh9cswS_lv68cZ6GuliI0dmcf6wEAp.71uV4ZR4pP0RzUX4NAVJAewtl2unujoI0CqmY9e10Iob92fmFg
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [patch 06/37] UML - Fix static linking
Date: Sat, 31 Mar 2007 03:21:17 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, JC.LAFOUCRIERE@cea.fr,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, Jeff Dike <jdike@linux.intel.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20070330205938.984247529@mini.kroah.org> <20070330210412.GH29450@kroah.com>
In-Reply-To: <20070330210412.GH29450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703310321.18453.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On venerdì 30 marzo 2007, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.

I have one objection, the fix has a typo! This is the additional fix 
(note '.note' instead of 'note'):

--- linux-2.6.git.orig/include/asm-um/common.lds.S
+++ linux-2.6.git/include/asm-um/common.lds.S
@@ -15,7 +15,7 @@
   PROVIDE (_unprotected_end = .);

   . = ALIGN(4096);
-  .note : { *(note.*) }
+  .note : { *(.note.*) }
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;

With this, the fix should be merged - I just re-hit this bug and rechecked 
everything, now it's ok.

> ------------------
> From: Jeff Dike <jdike@addtoit.com>
>
> During a static link, ld has started putting a .note section in the
> .uml.setup.init section.  This has the result that the UML setups
> begin with 32 bytes of garbage and UML crashes immediately on boot.
>
> This patch creates a specific .note section for ld to drop this stuff
> into.
>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  include/asm-um/common.lds.S |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/include/asm-um/common.lds.S
> +++ b/include/asm-um/common.lds.S
> @@ -15,6 +15,7 @@
>    PROVIDE (_unprotected_end = .);
>
>    . = ALIGN(4096);
> +  .note : { *(note.*) }
>    __start___ex_table = .;
>    __ex_table : { *(__ex_table) }
>    __stop___ex_table = .;



-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
