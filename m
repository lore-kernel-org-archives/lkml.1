Return-Path: <linux-kernel-owner+w=401wt.eu-S1161520AbXDWMfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161520AbXDWMfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161523AbXDWMfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:35:22 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:33279 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161520AbXDWMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:34:53 -0400
Message-ID: <462CA764.5080401@gmail.com>
Date: Mon, 23 Apr 2007 14:32:36 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>, Andrew Morton <akpm@osdl.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@stusta.de>, Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com>  <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet>  <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com>  <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com>  <462C7D74.60003@gmail.com> <1177327476.17026.75.camel@localhost.localdomain> <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------030603030204000309010909"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030603030204000309010909
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/23/2007 01:52 PM, Robert P. J. Day wrote:

> On Mon, 23 Apr 2007, Rusty Russell wrote:

>> Valid points have been made on both sides.  I suggest:
>>
>> #define MODULE_MAINTAINER(_maintainer) \
>> 	MODULE_AUTHOR("(Maintained by) "_maintainer)
> 
> why bring MODULE_AUTHOR into it?  just define it in terms of
> MODULE_INFO:
> 
> #define MODULE_MAINTAINER(_m) MODULE_INFO(_m, "(Maintained by)"  \
> 	maintainer)
> 
> technically, the maintainer is not the same as the author so why
> confuse the issue with an extra unnecessary macro expansion?

Swap arguments to MODULE_INFO, but yes, other than the extra "(Maintained 
by)" that's what was originally submitted:

http://lkml.org/lkml/2007/4/4/170

If you're going to be using a "maintainer" tag anyway as both that and yours 
above does, the "(Maintained by)" becomes superfluous, so we're back at the 
original.

I must say I'm not particularly sure either why reusing MODULE_AUTHOR would 
be better if MODULE_AUTHOR also remains (as Alan Cox pointed out might be 
desirable for legal reasons if nothing else). As fas as I'm aware, the other 
trivial patch I posted to init-module-tools:

http://lkml.org/lkml/2007/4/4/171

is all that's needed to make it useful.

But, I also really only care about being able to add MODULE_MAINTAINER() to 
some drivers that have outlived their authors and from that viewpoint there 
is no difference, so if Rusty feels this is better, so be it.

Andrew, mind if I submit this to you?

===
Provide MODULE_MAINTAINER() as a convenient place to stick a name and email 
address both for drivers having multiple (current and non-current) authors 
and for when someone who wants to maintain a driver isn't so much an author.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
===

Rene.


--------------030603030204000309010909
Content-Type: text/plain;
 name="module_maintainer2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="module_maintainer2.diff"

diff --git a/include/linux/module.h b/include/linux/module.h
index 10f771a..3c54774 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -128,6 +128,10 @@ extern struct module __this_module;
 /* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
+/* Maintainer, ideally of form NAME <EMAIL> */
+#define MODULE_MAINTAINER(_maintainer) \
+	MODULE_AUTHOR("(Maintained by) "_maintainer)
+
 /* What your module does. */
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
 

--------------030603030204000309010909--
