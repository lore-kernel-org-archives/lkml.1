Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXEPRtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXEPRtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXEPRtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:49:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398AbXEPRta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:49:30 -0400
Message-ID: <464B43BB.3070505@redhat.com>
Date: Wed, 16 May 2007 13:47:39 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B4155.9070902@gmail.com>
In-Reply-To: <464B4155.9070902@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> In 2.6.20.9 I can change trippoints:
> 
> echo "105:100:100:78:70:40:30" > /proc/acpi/thermal_zone/TZ0/trip_points
> echo 10  > /proc/acpi/thermal_zone/TZ0/polling_frequency
> 
> Then I got:
> cat /proc/acpi/thermal_zone/TZ0/*
> <setting not supported>
> cooling mode:   active
> polling frequency:       10 seconds
> state:                   active[2]
> temperature:             45 C
> critical (S5):           105 C
> active[0]:               78 C: devices=0xdf415a40
> active[1]:               70 C: devices=0xdf4159dc
> active[2]:               40 C: devices=0xdf41598c
> active[3]:               30 C: devices=0xdf41593c
> 
> cat /proc/acpi/fan/*/*
> status:                  off
> status:                  off
> status:                  on
> status:                  on
> 
> And fan turns on.
> 
> In 2.6.22-rc1-mm1:
> echo "105:100:100:78:70:40:30" > /proc/acpi/thermal_zone/TZ0/trip_points
> bash: echo: write error: BĹÄd wejĹcia/wyjĹcia (input/output error)
> 
> rutek:/home/maciek# cat /proc/acpi/thermal_zone/TZ0/*
> <setting not supported>
> polling frequency:       10 seconds
> state:                   ok
> temperature:             45 C
> critical (S5):           256 C
> active[0]:               78 C: devices=0xc1827a40
> active[1]:               70 C: devices=0xc18279dc
> active[2]:               60 C: devices=0xc182798c
> active[3]:               50 C: devices=0xc182793c
> rutek:/home/maciek# cat /proc/acpi/fan/*/*
> status:                  off
> status:                  off
> status:                  off
> status:                  off
> 
> Fan turns on when temperature is over 50*C. (want: 30)
> 
> A read this:
> http://article.gmane.org/gmane.linux.acpi.devel/22750
> 
> But I don't have colling_policy, but only colling_mode:
> ls /proc/acpi/thermal_zone/TZ0/
> cooling_mode  polling_frequency  state  temperature  trip_points
> 
> Its bug or feature?
> 

Committed to mainline May 10:

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=11ccc0f249cb01a129f54760b8ff087f242935d4
Commit:     11ccc0f249cb01a129f54760b8ff087f242935d4
Parent:     de46c33745f5e2ad594c72f2cf5f490861b16ce1
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Mon Apr 30 22:36:01 2007 -0400
Committer:  Len Brown <len.brown@intel.com>
CommitDate: Mon Apr 30 22:36:01 2007 -0400

    ACPI: thermal trip points are read-only
