Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZF3Iom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZF3Iom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 04:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZF3Ioe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 04:44:34 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48323 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZF3Ioe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 04:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=WdvfnjiZjtMvi3QbzktHkV5QMdETxJOlQEDmOjqzX/9xQm7FFfZ3Rs9QuuwZTWoSOI
         Zqe9S9m1AfljnsOD9IHeMHvudJOPeVKvakU+ZQRdDh2c21m3t+YVg1vfemi4bDGDA0QU
         BqmtPMzapo0yKPczsoAK6Tz6E36ftkEZwv3T0=
MIME-Version: 1.0
Date: Tue, 30 Jun 2009 10:44:35 +0200
Message-ID: <233789ed0906300144q209886b3qfb6737175a3660a0@mail.gmail.com>
Subject: Problem with wake_up using real-time scheduling
From: Zoltan Bus <zoltan.bus@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a problem on kernel 2.6.26.3. I have a real-time task which
uses the select system call to poll my audio driver. The sleeping task
is waken up by wake_up() from an interrupt handler.
The problem is, that the wake_up() function  sometimes does not wake
up the task if real-time priority is used.

The try_to_wake_up() returns from the out_running section, because of the check

      if (p->se.on_rq)
              goto out_running;

There are no other tasks running when the poll function is called.

Is this a known problem? Is it fixed somehow in newer versions?
Unfortunately I do not have the possibility to change the newest kernel version.
I am a newbie at linux, thank you very much for your help.

Zoltan
