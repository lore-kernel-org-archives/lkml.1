Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZJLPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZJLPnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZJLPnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:43:37 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57878 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZJLPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20091006074533.GA28889@july>
References: <20091006074533.GA28889@july>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 12 Oct 2009 17:42:08 +0200
Message-ID: <ac3eb2510910120842m3129b76fyaa11b509e7f97038@mail.gmail.com>
Subject: Re: [PATCH] Haptic class support (v2)
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       soni.trilok@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 09:45, Kyungmin Park <kmpark@infradead.org> wrote:
> This patch includes two haptic devices, isa1000 and isa1200
> ISA1000 is gpio based haptic, but isa1200 is based on I2C
> Both are working on Samsung SoCs and tested.
>
> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
> or
> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot

Please never add any custom files to the top-level of a class
directory. This place is reserved for devices, and not for custom
files. It's a serious bug in the layout and API of sysfs that this
allowed at all.

If you need these subsystem-wide contols please use a bus and not a
class to stuff these files into a place where they don't mix up with
the list of devices belonging to a class. Buses have all devices in a
devices/ subdir so they will not conflict.

Thanks,
Kay
