Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYKMOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYKMOxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKMOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:53:32 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9424 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKMOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jLiuKeXnDNCFocSQh6K6NZruFAJjNf29Pm7mNdtkRFCNX5oOihq3DBGVdRkxlr63PM
         6Rvf4Y84GVdCbpW9ZTXJDv1WyRLgKhO7w8zhwr6Cc/Awo3rYpHaUAuO6ebjnIBjpeUhi
         IS9nhm5l2f7NLXTjuZqOgA+Jdsrn/gUX8nwuo=
Message-ID: <8bd0f97a0811130647qeb5aea4tdc115f283bc352d@mail.gmail.com>
Date: Thu, 13 Nov 2008 09:47:00 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
Cc: vapier@gentoo.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
	 <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 08:43, Atsushi Nemoto wrote:
> On Wed, 12 Nov 2008 18:38:53 -0500, Mike Frysinger wrote:
>> +int parse_mtd(struct mtd_info *mtd, const char **probe_types,
>> +              struct mtd_partition *parts, int nr_parts)
>> +{
>> +#ifdef CONFIG_MTD_PARTITIONS
>> +     const char *default_part_probe_types[] = {
>> +             "cmdlinepart",
>> +             "RedBoot",
>> +             NULL
>> +     };
>
> But I'm not sure this default_part_probe_types is appropriate.
>
> How about enclose each parser with #ifdefs?
>
>        const char *default_part_probe_types[] = {
> #ifdef CONFIG_MTD_CMDLINE_PARTS
>                "cmdlinepart",
> #endif
> #ifdef CONFIG_MTD_REDBOOT_PARTS
>                "RedBoot",
> #endif
>                NULL
>        };
>
> This get rid of "RedBoot partition parsing not available" noise in
> boot message when you use default_part_probe_types without
> MTD_REDBOOT_PARTS.

yeah, that parsing thing is annoying, but i didnt think enough so to
add ifdef's.  i'm fine with it either way.
-mike
