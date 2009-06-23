Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZFWCH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZFWCH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZFWCHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:07:16 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:57716 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751511AbZFWCHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:07:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=owfLQ4z9RtEv/a9rppeve8SpK7AV8IM0sL+0TRm1GIXh37qCPSJGgwpMgzFbZJIrvEcCz472ijuUOGYmy6ujUvi2dsOtQvUiLbVBV46Bdiq5lvc7nwjMM8rrYAZBRJ25;
Date: Mon, 22 Jun 2009 19:07:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas =?UTF-8?B?SGVs?= =?UTF-8?B?bHN0csO2bQ==?= 
	<thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
Message-ID: <20090622190712.4c0ace71@jbarnes-g45>
In-Reply-To: <1245722325.4017.29.camel@pasglop>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	<4A3DABE1.50309@mit.edu>
	<alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	<alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	<alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	<cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	<alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	<alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	<4A3F3E3A.2030202@shipmail.org>
	<1245715213.4017.13.camel@pasglop>
	<alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	<1245719079.4017.25.camel@pasglop>
	<20090622181832.771dac03@jbarnes-g45>
	<1245722325.4017.29.camel@pasglop>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 11:58:44 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2009-06-22 at 18:18 -0700, Jesse Barnes wrote:
> > I think it could work, but ideally we'd keep the kernel fbcon object
> > pinned, and keep printing into it even while some other gfx app is
> > running.  That way we don't have to dump the whole queue into it
> > when a
> > panic occurs, we can just switch buffers (something like this would
> > also be handy for dual head debugging; one head running your desktop
> > and the other a debug console printing all the messages).  That's
> > slightly more invasive surgery though...  I should have a chance to
> > do something like that as part of the kdb/kms work I'll be doing
> > with Jason.
> > 
> Do we really need that ?
> 
> We can easily repaint (ie, regenerate the fb content from the pseudo
> vgacon image kept by the console layer).
> 
> So if we want the kernel to "take" over, it's reasonably easy to
> make it also repaint the content of the fb.

For just repainting panic messages, probably not.  For the dual head
case I talked about though it would sure be nice...

> How, of course, kicking out usespace with unmap_mapping_ranges() isn't
> going to work well from an oops or something at interrupt time, we
> do need to have a reasonably safe path for these things, which is why
> I believe that sort of emergency printing should be done without
> any acceleration, just basic manual painting in the front buffer...
> 
> Should we even bother changing the mode ? Not sure...

Yeah I don't think we should try to change the mode, unless we really
have to for whatever reason.  fbcon should generally be able to paint
to whatever we have up as long as we set it up properly.

-- 
Jesse Barnes, Intel Open Source Technology Center
