Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZAIVoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZAIVoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZAIVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:44:00 -0500
Received: from solo.fdn.fr ([80.67.169.19]:52016 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZAIVn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:43:59 -0500
Date: Fri, 9 Jan 2009 22:43:57 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: Re: Re (hello?): [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090109214357.GH5073@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org
References: <20090107005813.GA4987@const.famille.thibault.fr> <20090109212358.GG5073@const.famille.thibault.fr> <20090109213555.7f9275c9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090109213555.7f9275c9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Fri 09 Jan 2009 21:35:55 +0000, a écrit :
> Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> 
> > Came somebody have a look at this?  The need is real, the only question
> > that comes to my mind is whether notifiers are allowed to modify the
> > param they are given.  Since they are not marked const, I'd guess it'd
> > be ok?
> 
> The notifier code doesn't care.

I know, but I'm asking about current practice.

> > Make kbd_keycode() read param.value after calling the keyboard notification
> > chain, to let the callee change the translation on the fly. This for instance
> > permits to remap the physical positions of the keys independently of the
> > configured keymap, for e.g. single-handed people.
> 
> Surely that is just a new keymap ?

No. That would mean a lot of keymapSSS. Doing it the keymap way
would require to have us, us-revert-left, us-revert-right, en-uk,
uk-revert-left, uk-revert-right, etc. I really don't like that approach,
thus the "independently of the configured keymap".

This really is a problem that is orthogonal to keymaps: I'm here talking
about _physical_ keys remapping, not remapping what is printed on them
(which is done after that).

Samuel
