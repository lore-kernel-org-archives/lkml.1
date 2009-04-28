Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbZD1IKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbZD1IKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZD1IKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:10:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:36133 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZD1IK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:10:29 -0400
Date: Tue, 28 Apr 2009 10:10:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michael Brown <mebrown@michaels-house.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Douglas Warzecha <Douglas_Warzecha@dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090428101020.0e4c2b0c@hyperion.delvare>
In-Reply-To: <437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com>
References: <20090329174836.6de797d6@hyperion.delvare>
	<ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	<20090330104952.26f03c13@hyperion.delvare>
	<ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	<20090426085401.3788fc9c@hyperion.delvare>
	<20090427132041.GA18391@sc1430.michaels-house.net>
	<20090427172710.5a0c7f48@hyperion.delvare>
	<437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 12:23:30 -0500, Michael Brown wrote:
> On Mon, Apr 27, 2009 at 10:27 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > The question was: any change to _which_ paths exactly? Sysfs often
> > offers several ways to reach the same object, and it matters to know
> > which need to be preserved and which can change.
> >
> > const char *rbu_v2_fw_data_file = "/sys/class/firmware/dell_rbu/data";
> > const char *rbu_v2_fw_load_file = "/sys/class/firmware/dell_rbu/loading";
> > const char *rbu_v2_img_type_file = "/sys/devices/platform/dell_rbu/image_type";
> > const char *rbu_v2_pkt_size_file = "/sys/devices/platform/dell_rbu/packet_size";
> >
> > I guess that noawadays v2 applies, so the only path which needs to be
> > preserved is "/sys/class/firmware/dell_rbu". Is that correct? Is it the
> > same for srvadmin-hap?
> 
> You are correct WRT libsmbios. For hapi, I've cc'd Doug who can tell
> you about their code. I've done a quick grep of their code, and the
> paths above look like the same ones he is using, but I could be wrong.
> 
> hapi/apilibrary/dchbas/linux/umhbaslx.c:#define
> HBAS_RBU_SYSFS_NEW_DATAREAD_PFNAME		"/sys/devices/platform/dell_rbu/data"
> hapi/apilibrary/dchbas/linux/umhbaslx.c:#define
> HBAS_RBU_SYSFS_NEW_IMAGETYPE_PFNAME		"/sys/devices/platform/dell_rbu/image_type"
> hapi/apilibrary/dchbas/linux/umhbaslx.c:#define
> HBAS_RBU_SYSFS_NEW_PKTSIZE_PFNAME		"/sys/devices/platform/dell_rbu/packet_size"

This doesn't make use of the firmware class at all, so I guess it won't
be affected by any change to the firmware class?

-- 
Jean Delvare
