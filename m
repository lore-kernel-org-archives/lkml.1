Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbYEYJu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbYEYJu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYEYJuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:50:19 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:59163 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYEYJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:50:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 11:49:40 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211707837.17151.14.camel@johannes.berg>
In-Reply-To: <1211707837.17151.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251149.41059.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 11:30:37 Johannes Berg wrote:
> > I explained this a couple of times. The request_firmware() is an  
> > abstract mechanism that can request a firmware file. The location of  
> > the firmware file is up to the userspace. The kernel requests a  
> > particular file and that is it. All namespacing has to be done by the  
> > firmware helper script (nowadays udev). That the current  
> > implementation of the firmware helper maps the filename 1:1 to a file  
> > under /lib/firmware/ just works, but doesn't have to work all the  
> > time. It is not the agreed contract between kernel and userspace.
> 
> I don't buy this argument. I could agree if you said that the "agreed
> contract" between the kernel and userspace is for the kernel to request
> a firmware file /keyed by an arbitrary, null-terminated string/.

I fully agree with johannes, that using / as a grouping-separator is a
_nice_ idea and userspace must support it, regardless of the actual
storage system it is using.

Currently using a single directory for one driver really enhances the way
firmware can be handled. For example, we can have several different versions
cleanly installed in /lib/firmware. For example, on my development machine
I have
/lib/firmware/b43
/lib/firmware/b43-old
/lib/firmware/b43-open
/lib/firmware/b43legacy
Putting all these files into plain /lib/firmware would require changing the
actual filenames and that would be a real pain. (This can be up to about 100 files).

> The fact that it is usually stored on a filesystem where / means a
> directory (and thus grouping) can be seen as a nice convenience of the
> filesystem storage, but if firmware was stored elsewhere then you could
> degrade to the simple key-based lookup that happens to allow "/" as a
> character in the keys.
> 
> And because the kernel is nice, it allows userspace to use a filesystem
> storage by not using paths like "../../lib/firmware/asdf". But
> fundamentally, I don't even see anything wrong with that.

I agree that .. and . should probably be avoided.
And I also don't see a good reason to use them.

> Put another way, you can have pretty arbitrary firmware firmware names
> (though since humans need to handle them you want printable characters),
> and I don't see why now all the sudden you would treat "/" specially by
> *explicitly* disallowing it.
> 
> b43 comes with 22 firmware files for a single driver, and groups them

Depending on the firmware version you have, there are over 30 files
for b43 and b43legacy each.

> using "b43/<name>". What you're proposing will make firmware fail
> *again* for all users, and we got a *LOT* of flak from all kinds of
> stakeholders (not just the users) when firmware upgrades were required,
> doing it again for such a petty reason is ridiculous.

Yeah. I'm not going to change that. The users are going to kill us.
Besides that, there were very good reasons to start grouping the files
in b43 (bcm43xx didn't do it), as it simply was unmaintainable in bcm43xx.

-- 
Greetings Michael.
