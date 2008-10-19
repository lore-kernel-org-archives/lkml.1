Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYJSWXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYJSWXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJSWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:23:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:54711 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789AbYJSWX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:23:28 -0400
Date: Mon, 20 Oct 2008 00:23:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Noonan <steven@uplinklabs.net>,
       Justin Mattock <justinmattock@gmail.com>,
       Sven Anders <anders@anduras.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org
Subject: [PATCH 2/2] HID: fix appletouch regression (was Re: several
 messages)
In-Reply-To: <48FBB012.40605@gmail.com>
Message-ID: <alpine.LNX.1.10.0810200017150.27479@jikos.suse.cz>
References: <1224425749-22652-1-git-send-email-jirislaby@gmail.com> <1224425749-22652-2-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0810192135010.27479@jikos.suse.cz> <48FBB012.40605@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ restored previous subject, sorry for the "several messagess" mess, 
alpine didn't handle multi-message reply with different subjects nicely ]

On Mon, 20 Oct 2008, Jiri Slaby wrote:

> >> +enum hid_type {
> >> +	HID_TYPE_UNKNOWN = 0,
> >> +	HID_TYPE_MOUSE,
> >> +	HID_TYPE_KEYBOARD
> > Do we really need the HID_TYPE_KEYBOARD at all? It's not used anywhere 
> > in the code. I'd propose to add it when it is actually needed. I.e. 
> > have the enum contain something like HID_TYPE_MOUSE HID_TYPE_OTHER for 
> > now, and add whatever will become necessary in the future, what do you 
> > think?
> I would use unknown rather than other, since on bluetooth mouse is unknown
> not other, if you don't mind?
> Or did you mean tristate unknown, mouse and other?

Well, basically the points I am trying to make:

1) the code doesn't currently need HID_TYPE_KEYBOARD at all

and

2) by definition, HID are not just mice and keyboards, so adding just 
   these two doesn't look particularly correct, if just one of them is 
   needed

For bluetooth we even don't have the possibility to distinguish these, 
yes. So probably something like HID_TYPE_USBMOUSE/HID_TYPE_OTHER for now, 
and we could extend the enum whenever the need to recognize a different 
type comes up?

Thanks,

-- 
Jiri Kosina
SUSE Labs
