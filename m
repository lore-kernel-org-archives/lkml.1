Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbYKNGvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbYKNGvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 01:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYKNGvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 01:51:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:63627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYKNGvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 01:51:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=c55dccoe0BgXpqyejZO/5OawiXR6QqFgLnHuwW6jgc8Zwo5LK1yqnMnNFxiIsEL9b5
         ZRFFZzXw7znVI8Wk3Wp6ygR3cH5zBvUag7BWwNnarYIIDHKbN39hWka1Tb3jB6N5un+0
         KnzDIUlCiVrJBkNheU47GeqNadjb6gqFFXc08=
Date: Fri, 14 Nov 2008 07:49:19 +0100
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Message-ID: <20081114064919.GB29121@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Wolfram Sang <w.sang@pengutronix.de>,
	Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
References: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de> <20081112135522.GD8302@shadowen.org> <9ea470500811120623q4334f840t4540649edba935@mail.gmail.com> <20081113225540.GA11912@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113225540.GA11912@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Nov 13, 2008 at 11:55:40PM +0100, Wolfram Sang wrote:
> Hello Boris,
> 
> > files. Well, this one suffers from the exact opposite problem - it won't trigger
> > even if it is a -p0 patch on new files, AFAICT.
> 
> Can you give an example, please? I fail to see this at the moment.

Watch this:

Here's an arbitrary piece of a patch one could create:

--- /dev/null   2008-11-09 02:46:02.525014459 +0100
+++ arch/x86/kernel/tsc_resync.c        2008-11-14 07:22:34.000000000 +0100
@@ -0,0 +1 @@
+This is a new file

and, as you can see, it is a -p0 patch. Now, in the code you do:

if ($tree && -e "$root/$p1_prefix") {
	WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");

and the "$root/$p1_prefix" won't exist - as a matter of fact - would
lose its "arch" part due to the regex before and the if-condition won't
trigger.

Nevertheless, this can be made to work if a special condition is added
which looks for "/dev/null" or similar strings which are a unique for a
patch adding a new file, or something like that. But I admit, this is a
contrived case and as such it is really rare in reality and you never
gonna have a problem like that if you use git or quilt :).

-- 
Regards/Gruss,
    Boris.
