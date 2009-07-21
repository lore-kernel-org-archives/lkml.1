Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZGUQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZGUQff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZGUQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:35:34 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:34311 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZGUQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=c5EXkhsG8EbfgAOywReNxO9TZ69oHDEqvgCahOUpN9zBTmP2hhHkpn5i2k/bgSjaCg
         QtvvrNE6fO8/dBnDDi86LAL+GDQSk5xA1QleONi8EgMbfb3M4QATdhGpd4SaJo03XQXH
         L8KAE4bo0czC6O8bSwuGxwQJMRAc1fGjcRm3Y=
MIME-Version: 1.0
In-Reply-To: <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com>
References: <cover.1248190728.git.jbaron@redhat.com> <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 21 Jul 2009 09:26:54 -0700
X-Google-Sender-Auth: 27f59657fefb1093
Message-ID: <2c0942db0907210926ra96ee33ke3e6ac8c57458be8@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_counter: detect debugfs location
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 9:20 AM, Jason Baron <jbaron@redhat.com> wrote:
>
> Search for the debugfs filesystem in /proc/mounts, but also allows the user to
> specify '--debugfs-dir=blah' or set the environment variable: 'PERF_DIR_DEBUGFS'

> -static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";

There are server systems out there that run with thousands of mounts.
It would be kinder to the users of those systems (ie, faster perf
startup) if you only went rooting around /proc/mounts if opening the
default location failed.
