Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZKBHoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZKBHoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZKBHoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:44:17 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56212 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbZKBHoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=O/XT96JEKm0CoLEtaZx1XoQ1PQJUFqj7QfKy5ac6QdQCkF1EK9pPUctVnVBkFA6+qt
         BbUpBH0a4Tzm/30HIArhbvJTeGJZGSmh48Ar2eOeoP6IBzvsLy4PdcjdGbb0v6zoP1/l
         Sm48wBBbRZmZ6sirW8CMb0PZQdg1gmvtNcclQ=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 15:44:22 +0800
Message-ID: <b741c2440911012344n7a6f7241ma873abac2fc9507e@mail.gmail.com>
Subject: [PATCH 0/3] Fix the 'current css_set' problem in debug subsystem
From: Liu Aleaxander <aleaxander@gmail.com>
To: menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all.

(Sorry for the resending, it seems I opened the HTML encoding before)

This a three-patch set to fix the 'current css_set' problem in debug
subsystem of cgroup system. (well, in fact, it's a two-patch set; the
third one just fixes a typo).

Say I mount a cgroup fs in /cgroup, and here is the problem:
$ cat debug.current_css_set_refcount
268
$ mkdir test
$ cd test
$ cat debug.curernt_css_set_refcount
268

$ echo $$ > tasks
$ cat debug.current_css_set_refcount
2
$ cd ../
$ cat debug.current_css_set_refcount
2

That means it always print the css_set_refcount of the cgroup that
comprise the current task(bash, here), instead of the current cgroup
whatever cgroup you are in. And this would be meaningless to put the
same content in all the cgroups. So, to make it more meaningful, we
should make it print the css_set_refcount of the cgroup you are
currently in.

Patch 1 adds a cgroup_first_css_set function to get the current
css_set of one cgroup.
Patch 2 fixes the problem.
Patch 3 just fixes a typo.

--
regards
Liu Aleaxander
