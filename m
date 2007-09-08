Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXIHWuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXIHWuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 18:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXIHWuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 18:50:00 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:53724 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXIHWt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 18:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FC8FyJZUPcryIfwOUetJprZ+i9v//bp4y91t9cR4ovfNznvIoTccLKu1/E+I2DKiVGPLCrNuczEAylowxjwEjEe+q2JpmdNPoyJdYIYyeYb8ho/A1B9s4O0mEgTCnreZSYRsWV699Gld0Wwoo+TXMCvZTsyyFfHOkSvLMY7Om1c=
Message-ID: <32209efe0709081549t6df0a7d8m31389af92d84d60d@mail.gmail.com>
Date: Sat, 8 Sep 2007 15:49:57 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Rik van Riel" <riel@redhat.com>
Subject: Re: Linux' IEEE 1394/ FireWire subsystem TODO list
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3dc235e8330be9c6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <tkrat.3dc235e8330be9c6@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Hi lists,
>
> I copied the ancient linux1394 project TODO list from the static page at
> www.linux1394.org over to http://wiki.linux1394.org/ToDo and
> substantially updated it now.  I certainly missed a few important TODOs
> and ideas, but the list is quite long nevertheless.  I thought of
> posting a FireWire driver status report to LKML recently --- so I am
> simply posting the TODO list now.  Another page related to FireWire
> driver development status is http://wiki.linux1394.org/JujuMigration .
>
> Reply or edit the wiki if you have additions or disagree with a TODO
> item.  AFAIK wiki.linux1394.org does not require registration for
> editing.
>
>
>   Linux1394 Project TODO List
>
> See our list of bugs
> <http://bugzilla.kernel.org/buglist.cgi?product=Drivers&component=IEEE1394&bug_status=NEW&bug_status=ASSIGNED&bug_status=DEFERRED&bug_status=NEEDINFO>
> at bugzilla.kernel.org. There are also bugs filed in distributors' bug
> trackers but they are not as easy to query.
>
> Contents
>
>   IEEE1394 Subsystem (a.k.a. Linux1394 driver stack)
>     * subsystem and core driver
>     * sbp2
>     * ether1394
>     * raw1394
>   FireWire subsystem (a.k.a. Juju driver stack)
>     * support in userspace
>     * subsystem and core driver
>     * firewire-ohci
>     * firewire-sbp2
>
> ------------------------------------------------------------------------
>
>
> IEEE1394 Subsystem (a.k.a. Linux1394 driver stack)
>
>
>   subsystem and core driver
>
>     * Bug 8403 <http://bugzilla.kernel.org/show_bug.cgi?id=8403>: If
>       several Linux boxes are plugged into the same bus, they may go
>       multiple forced bus resets, fighting over who gets to be IRM. Our
>       IRM code is too pessimistic if errors happen when querying the
>       remote IRM for its capabilities.
>
>     * Handle same node being connected to multiple local hosts
>       (multi-pathing).
>
>
>   sbp2
>
>     * Bug 1872 <http://bugzilla.kernel.org/show_bug.cgi?id=1872>: Fix
>       serialize_io=0.
>
>     * Implement per-node queueing options.
>
>   Also see sbp2's TODO list in the source
>   <http://lxr.linux.no/source/drivers/ieee1394/sbp2.c#L38>.
>
>
>   ether1394
>
>     * Improve reliability (bug 8361
>       <http://bugzilla.kernel.org/show_bug.cgi?id=8361>, bug 8704
>       <http://bugzilla.kernel.org/show_bug.cgi?id=8704>). Fix "Waking
>       dma ctx=0 ... processing is probably too slow", perhaps by
>       increasing the AR DMA buffer size in ohci1394.
>
>     * Implement MCAP and multicast support.
>
>
>   raw1394
>
>     * Bug 4779 <http://bugzilla.kernel.org/show_bug.cgi?id=4779>: Test
>       and fix 32bit userland on 64bit kernel. It appears that only
>       address range mapping is still buggy as of Linux 2.6.23.
>
>     * Implement access to RAW1394_REQ_MODIFY_ROM in libraw1394. This
>       should be used instead of RAW1394_REQ_UPDATE_ROM. Make sure that
>       the RAW1394_REQ_MODIFY_ROM accessor can be ported to the ROM
>       manipulation ioctl of the new firewire-core ABI, which should
>       eventually be fully supported by libraw1394 too.
>
> ------------------------------------------------------------------------
>
>
> FireWire subsystem (a.k.a. Juju driver stack)
>
>
>   support in userspace
>
>     * Finish support by libraw1394.
>
>     * Add support in libdc1394 v1?
>
>     * Add support in FFmpeg's libavformat.
>
>
>   subsystem and core driver
>
>     * Replace fw_notify() and fw_error() (defined in
>       drivers/firewire/fw-transaction.h) by dev_notice() and dev_err()
>       (defined in include/linux/device.h).
>
>     * Implement IPv4 over FireWire as per RFC 2734, i.e. port the
>       functionality of eth1394 to the new driver stack. But try not to
>       port eth1394's bugs too.
>
>     * Add IPv6 support as per RFC 3146.
>
>     * Implement an SBP-2 target using the in-kernel SCSI target
>       framework as an alternative to Endpoint (Oracle's SBP-2 target
>       implementation in userspace).
>
>
>   firewire-ohci
>
>     * Implement isochronous I/O for OHCI 1.0 compliant chips (such as
>       VIA VT6306 and chips from NEC and Ricoh which are not OHCI 1.1
>       compliant). That is, implement a mode which does not require
>       dual-buffer IR DMA.
>
>     * Bug 8828 <http://bugzilla.kernel.org/show_bug.cgi?id=8828>: Come
>       up with a quirk fix for NForce2. The person to do so will most
>       certainly require direct access to this hardware. Note, the
>       NForce2 workaround in ohci1394 is unacceptable by today's
>       standards as it involves busy-waiting in the interrupt handler.
>       Either we find something better for firewire-ohci, or NForce2
>       remains unsupported in firewire-ohci.
>
>     * Quirk fix for old Apple UniNorth adapters?
>
>     * There seem to be issues with ALi controllers.
>
>
>   firewire-sbp2
>
>     * Eliminate calls to fw_memcpy_to_be32() by directly writing in big
>       endian into struct fields of ORBs etc..
>
>     * Fix remaining device recognition bugs. Best done in hands-on mode
>       rather than via e-mail debugging.
>
>     * Implement hand-over from OpenFirmware login. When an Apple PC
>       boots from a FireWire disk, the OpenFirmware is already logged in
>       but does apparently not log out after it loaded the kernel image.
>       When then the kernel's firewire-sbp2 (or sbp2, for that matter)
>       logs in, the target may deny access. This has been observed with
>       Momobay CX-1. The old ieee1394 driver stack somehow overcomes this
>       because of timing subtleties, but firewire-sbp2 ends up with
>       failed login due to denied access.
>
>     * Implement dynamically appended ORB lists for performance
>       improvement. Note, the old sbp2 driver's implementation of ORB
>       lists is very buggy and does not seem to improve performance
>       noticeably.
>
>     * Implement SBP-3 FASTSTART protocol which is rumored to be
>       supported by newer OxSemi bridges.
>
>     * Bug 3225 <http://bugzilla.kernel.org/show_bug.cgi?id=3225>:
>       Integrate with scsi_wait_scan module?
>
>
> PS: It seems also appropriate to disclose the current manpower behind
> FireWire driver development and maintenance.  There are just two people
> who regularly work on the drivers:  Kristian Høgsberg (author and
> maintainer of the new firewire subsystem, in the past also involved with
> the old ieee1394 subsystem) and me (co-maintainer of both the new and
> old subsystems).  But we both have a lot of other projects going on at
> the moment.
> --
> Stefan Richter


This is such a good format and great information for those who would
like jump in. They can choose and start working on the item that is
best suited by complexity and how time intensive it is.
I've seen individual todo lists on some preject pages, wish I was
recording such information, so we could gather all the pointers on the
common page. There is page maintained by Rick An Riel
http://kernelnewbies.org/KernelProjects which is just perfect for
adding all the links to kernel projects' roadmaps and todo items.
Would you mind to tie up your todo project link to this page Stefen?
Rick, I have a random list of potential projects that I should
probably first send to corresponding maintainers for review and
approval. But I think that ieee1394 will be great first item.
Regard,
--Natalie

> -=====-=-=== =--= -=---
> http://arcgraph.de/sr/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
