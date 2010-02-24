Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0BXN2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:28:34 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53036 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0BXN2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:28:32 -0500
MIME-Version: 1.0
In-Reply-To: <4B849B73.1040106@cn.fujitsu.com>
References: <4B849B73.1040106@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 15:28:31 +0200
Message-ID: <cc557aab1002240528t28eae36dj976525be2fcf7246@mail.gmail.com>
Subject: Re: [PATCH -mm] cgroups: fix failure path in cgroup_write_event_control()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 5:22 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> How to reproduce:
>
>  # mount -t cgroup -o memory xxx /cgroup
>  # mkdir /cgroup/tmp
>  # ./cgroup_event_listener /cgroup/tmp/cgroup.event_control abc
>  ^C
>  # rmdir /cgroup/tmp
>  # cat /proc/cgroups | grep memory
>  memory  2       2       1         (should be "2 1 1")
>  # umount /cgroup
>  (failed!)
>
> Using a single goto label to cleanup multi failure paths can
> get things wrong quite easily, while multi labels makes the
> code cleaner.

I disagree.
It's easer to make mistake on changing code with multi failure
paths, if you want to move a code within function.
