Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZEAJDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZEAJDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZEAJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:03:36 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:51836 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbZEAJDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:03:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: What's in hid.git for 2.6.30
Date: Fri, 1 May 2009 11:02:18 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <200905010102.34272.oliver@neukum.org> <alpine.LNX.2.00.0905010103550.5012@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0905010103550.5012@wotan.suse.de>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905011102.18945.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday 01 May 2009 01:09:12 schrieben Sie:
> On Fri, 1 May 2009, Oliver Neukum wrote:
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -1824,6 +1824,9 @@ int hid_check_keys_pressed(struct hid_device
> > > *hid) struct hid_input *hidinput;
> > >         int i;
> > >  
> > > +       if (!(hid->claimed & HID_CLAIMED_INPUT))
> > > +               return 0;
> > > +
> >
> > is there a guarantee all keyboards will be claimed as input devices?
>
> Hi Oliver,
>
> do you see any way how hid->inputs could currently be initialized other
> than the device being claimed by hid-input?

No, but I am worried about a false return of 0 here, not the other way
round. This method is necessary because keyboards don't wake up
if a key is released. Suspending a keyboard with a key pressed will lead
to an endless repetition of that key.
So I wonder whether it is possible to have a keyboard not claimed as an
input device.

	Regards
		Oliver

