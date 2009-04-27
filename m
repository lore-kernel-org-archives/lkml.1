Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZD0P1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZD0P1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZD0P11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:27:27 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4370 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbZD0P11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:27:27 -0400
Date: Mon, 27 Apr 2009 17:27:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michael E Brown <mebrown@michaels-house.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090427172710.5a0c7f48@hyperion.delvare>
In-Reply-To: <20090427132041.GA18391@sc1430.michaels-house.net>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	<20090330104952.26f03c13@hyperion.delvare>
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	<20090426085401.3788fc9c@hyperion.delvare>
	<20090427132041.GA18391@sc1430.michaels-house.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, 27 Apr 2009 08:20:43 -0500, Michael E Brown wrote:
> On Sun, Apr 26, 2009 at 08:54:01AM +0200, Jean Delvare wrote:
> > Hi Kay,
> > 
> > Sorry, completely overlooked your reply... Ah, now I remember, I was
> > waiting for Michael to show up and comment on this. Michael, ping? As
> > long as we don't know the exact requirements and constraints of the
> > dell firmware tool, we're somewhat stuck.
> > 
> > Matt, maybe you can help? Could you please point us to the source code
> > of the dell firmware tool which relies on the dell_rbu driver?
> 
> Sorry about that. Skimmed the thread and looks like I missed out...
> 
> The problem is that there are two users: 1) libsmbios as Matt has
> already mentioned, and 2) Dell OpenMange Server Administrator.
> Specifically srvadmin-hapi has the code to use the dell_rbu code
> (proprietary, no source available). The srvadmin-hapi code is embedded
> into all Dell Update Packages (DUPs).
> 
> The problem being that any change to the paths breaks all released DUPs.

The question was: any change to _which_ paths exactly? Sysfs often
offers several ways to reach the same object, and it matters to know
which need to be preserved and which can change.

Looking at src/libsmbios_c++/rbu/Rbu_Linux.cpp, I see the following
paths are used:

const char *rbu_v1_mono_data_file = "/sys/firmware/rbu/rbudata";
const char *rbu_v1_mono_size_file = "/sys/firmware/rbu/rbudatasize";
const char *rbu_v1_pkt_data_file = "/sys/firmware/rbu/packetdata";
const char *rbu_v1_pkt_size_file = "/sys/firmware/rbu/packetdatasize";

const char *rbu_v2_fw_data_file = "/sys/class/firmware/dell_rbu/data";
const char *rbu_v2_fw_load_file = "/sys/class/firmware/dell_rbu/loading";
const char *rbu_v2_img_type_file = "/sys/devices/platform/dell_rbu/image_type";
const char *rbu_v2_pkt_size_file = "/sys/devices/platform/dell_rbu/packet_size";

I guess that noawadays v2 applies, so the only path which needs to be
preserved is "/sys/class/firmware/dell_rbu". Is that correct? Is it the
same for srvadmin-hap?

Thanks,
-- 
Jean Delvare
