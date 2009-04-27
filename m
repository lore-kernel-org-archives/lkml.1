Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZD0RXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZD0RXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZD0RXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:23:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53570 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZD0RXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cCtSNP3nk4F8ovd0R56GnmR7SJNXGx5jb/4UKt6lumIj4gdy9a7CAaBEP5dxvzn1Rn
         uQpu+1Yr9v784mEHlNToQHKze0PITnzrKI6QP1rLpJcCNz4s1HrO+wxSGFeIS4Eukzhi
         DRFD/9sIz5OKOVGScQvrWT2z9B4eqs/LuiIgk=
MIME-Version: 1.0
In-Reply-To: <20090427172710.5a0c7f48@hyperion.delvare>
References: <20090329174836.6de797d6@hyperion.delvare>
	 <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	 <20090330104952.26f03c13@hyperion.delvare>
	 <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
	 <20090426085401.3788fc9c@hyperion.delvare>
	 <20090427132041.GA18391@sc1430.michaels-house.net>
	 <20090427172710.5a0c7f48@hyperion.delvare>
Date: Mon, 27 Apr 2009 12:23:30 -0500
X-Google-Sender-Auth: ac18f4be4a5a5efd
Message-ID: <437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com>
Subject: Re: Class device namespaces
From: Michael Brown <mebrown@michaels-house.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Douglas Warzecha <Douglas_Warzecha@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:27 AM, Jean Delvare <khali@linux-fr.org> wrote:
> The question was: any change to _which_ paths exactly? Sysfs often
> offers several ways to reach the same object, and it matters to know
> which need to be preserved and which can change.
>
> const char *rbu_v2_fw_data_file = "/sys/class/firmware/dell_rbu/data";
> const char *rbu_v2_fw_load_file = "/sys/class/firmware/dell_rbu/loading";
> const char *rbu_v2_img_type_file = "/sys/devices/platform/dell_rbu/image_type";
> const char *rbu_v2_pkt_size_file = "/sys/devices/platform/dell_rbu/packet_size";
>
> I guess that noawadays v2 applies, so the only path which needs to be
> preserved is "/sys/class/firmware/dell_rbu". Is that correct? Is it the
> same for srvadmin-hap?

You are correct WRT libsmbios. For hapi, I've cc'd Doug who can tell
you about their code. I've done a quick grep of their code, and the
paths above look like the same ones he is using, but I could be wrong.

hapi/apilibrary/dchbas/linux/umhbaslx.c:#define
HBAS_RBU_SYSFS_NEW_DATAREAD_PFNAME		"/sys/devices/platform/dell_rbu/data"
hapi/apilibrary/dchbas/linux/umhbaslx.c:#define
HBAS_RBU_SYSFS_NEW_IMAGETYPE_PFNAME		"/sys/devices/platform/dell_rbu/image_type"
hapi/apilibrary/dchbas/linux/umhbaslx.c:#define
HBAS_RBU_SYSFS_NEW_PKTSIZE_PFNAME		"/sys/devices/platform/dell_rbu/packet_size"

--
Michael
