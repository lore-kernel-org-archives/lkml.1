Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbXJVBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbXJVBMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 21:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXJVBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 21:12:13 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:51370 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751032AbXJVBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 21:12:12 -0400
Message-ID: <471BF8EF.20605@crispincowan.com>
Date: Sun, 21 Oct 2007 18:12:15 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: Re: LSM conversion to static interface
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To discuss how LSM should work, it would have been really helpful if the
OP had cc'd the LSM mailing list. I've cc'd the LSM list here ...

Linus Torvalds wrote:
> On Wed, 17 Oct 2007, Thomas Fricaccia wrote:
>   
>> But then I noticed that, while the LSM would remain in existence, it was 
>> being closed to out-of-tree security frameworks.  Yikes!  Since then, 
>> I've been following the rush to put SMACK, TOMOYO and AppArmor 
>> "in-tree".
>>     
> Yeah, it did come up. Andrew, when he sent it on to me, said that the SuSE 
> people were ok with it (AppArmor), but I'm with you - I applied it, but 
> I'm also perfectly willing to unapply it if there actually are valid 
> out-of-tree users that people push for not merging.
>   
I did not speak up against this patch because it does not hurt AppArmor,
and I was trying to reduce the amount of LKML flaming that I engage in
:) but since you asked, IMHO this patch is extremely bad for Linux and
bad for Linux users.

The patch does have benefits, I just think those benefits are weak and
unimportant. It prohibits dynamic loading of security modules (you must
be compiled in) and prohibits unloading of security modules (because it
is unsafe, and potentially insecure). What makes these benefits weak and
unimportant is that you can have those benefits now without the patch by
just writing your module that way: if you think that a security module
should be compiled in and present when the kernel boots, and should
never be unloaded.

> For example, I do kind of see the point that a "real" security model might 
> want to be compiled-in, and not something you override from a module. Of 
> course, I'm personally trying to not use any modules at all, so I'm just 
> odd and contrary, so whatever..
>   
Why would you want to dynamically unload a module: because it is
convenient for debugging. Ok, so it is unsafe, and sometimes wedges your
kernel, which sometimes forces you to reboot. With this patch in place,
it forces you to *always* reboot when you want to try a hack to the module.

Why you would want to dynamically load a security module: because you
are an enterprise user, required to use a specific build of a kernel,
rather than compile your own kernel, but you also want to use (or even
try out) a security module that your enterprise's vendor of choice has
not chosen to bundle. In the current state, such a user can just go get
a module and use it. With this patch, such a user is just screwed, they
can't load and try the module without having to get into kernel building.

So the net impact of this patch is:

    * It takes a deployment practice (static compiled-in security) that
      is arguably good in many circumstances and makes it mandatory at
      all times.
    * It takes a development practice that is very convenient and
      slightly risky, and forces you into the pessimal inconvenient
      development practice at all times.
    * It prevents enterprise users, and in fact anyone who isn't
      comfortable compiling their own kernel, from ever trying out any
      security module that their distro vendor of choice did not ship.

This strikes me as a rather anti-choice position to take. It says that
because candy is bad for you, you only ever get to eat vegetables. I
don't understand why Linux would want to do this to its users.

It doesn't hurt me or AppArmor. Since AppArmor is now shipping with
SUSE, Ubuntu, and Mandriva, what this does is make it harder for newer
modules like TOMOYO, Multi-Admin, etc, to get exposure to enterprise
users. So I don't think I am being self-serving in arguing against this
patch. I just think it is bad for Linux.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work

