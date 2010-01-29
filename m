Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532Ab0A2Np6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0A2Np6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478Ab0A2Np4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:45:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0A2Npz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:45:55 -0500
Date: Fri, 29 Jan 2010 13:45:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Toralf F?rster <toralf.foerster@gmx.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: Re: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10
	>/dev/null'
Message-ID: <20100129134551.GR19799@ZenIV.linux.org.uk>
References: <201001212017.00160.toralf.foerster@gmx.de> <20100121203535.GA5133@x200> <201001212219.03718.toralf.foerster@gmx.de> <alpine.LRH.2.00.1001261416430.15694@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1001261416430.15694@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 02:17:32PM +0100, Jiri Kosina wrote:
> > > Please, find out which file is causing this, if it's reproducible.
> > > 
> > I reproduced the msg :
> > "ACPI: Please implement acpi_video_bus_ROM_seq_show" by :
> > by
> > $> head -c 10 /proc/acpi/video/VID/info
> > 
> > After suspend to disk and wakeup however the file /proc/acpi/video/VID/ROM was 
> > the culprit.
> > 
> > The trace however I can't reproduce until now.

*snort*
The message is caused by
        printk(KERN_INFO PREFIX "Please implement %s\n", __func__);
        seq_printf(seq, "<TODO>\n");
in acpi_video_bus_ROM_seq_show(), so it's not surprising.  Shouldn't spew
to syslog, but other than that it's a non-issue.  Stack trace, OTOH, is
something very different; something is trying to generate 2Mb of contents
in a single ->show().  Which is definitely not that one - "<TODO>\n" is
not going to eat that much ;-)
