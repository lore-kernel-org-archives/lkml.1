Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbYBBSsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbYBBSsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBBSsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:48:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56966 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbYBBSsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:48:22 -0500
Date: Sat, 2 Feb 2008 19:48:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Incompatibility of "const" and __xxxinitdata?
Message-ID: <20080202184825.GE25399@uranus.ravnborg.org>
References: <804dabb00802020720p2684dd1eyc29d1e1410407e08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802020720p2684dd1eyc29d1e1410407e08@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 11:20:44PM +0800, Peter Teoh wrote:
> In include/linux/init.h, it is documented that all __xxxinitdata
> declaration must not have constant, as show below:
> 
>  *
>  * static int init_variable __initdata = 0;
>  * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
>  *
>  * Don't forget to initialize data not at file scope, i.e. within a function,
>  * as gcc otherwise puts the data into the bss section and not into the init
>  * section.
>  *
>  * Also note, that this data cannot be "const".
>  */
> 
> In this same init.h is also documented the preferred way of
> typecasting the variable with __initdata.
> 
> But searching through the source codes, I have found many instances of:
> 
> 1.   constant occuring in the __xxxinitdata pattern, and
> 2.   non-conformance of the variable declaration according to the
> codingstyle recommended.

Only very recently we had a tag to annotate const data in addition
to the __initdata tag.
The reason for two tags are that gcc does not allow to mix const
and non-const data in the same section.

So in the cases you list below there are most certainly no other
__initdata annotations or at least not to non-const data.

If you go forward and fix up this stuff do so in adequate steps.
So you for example do not mix net drivers with usb drivers
in the same patch.

And if fix it up then use the recommended style for the
annotation.
Improved documentation in init.h is also welcome!

	Sam
