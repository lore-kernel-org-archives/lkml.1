Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZE2Mv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZE2Mv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbZE2Mvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:51:52 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48940 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbZE2Mvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GCjZq/o+pkMIQFJh9m5fZUJwswJ5xQTkPS6SZZxvgLrK34bS/R2SySBXHKdohRMUOi
         vuX29q8dpLCSpapPad3EPXMtMZifm2ezW+eSIzSIheqehgysly7DPCxrf6NaPeyD5UOr
         nE0dBGEk8IjERbcRWbv51oqHYNLBqYm+xB6cI=
MIME-Version: 1.0
Date: Fri, 29 May 2009 15:51:52 +0300
Message-ID: <b0b0b0000905290551t7e0a081bm814de19a8101814a@mail.gmail.com>
Subject: per user memory limit and LSM module
From: Iliya <vnsavage@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
I'd like to limit the memory usage per user, using LSM based module.
The vm_enough_memory LSM hook is convenient enough , but to make use
of it , I would need sum of all the memory usage by the current user.
The easiest way I could think of was traversing through all the
processes with for_each_process() , checking for the uid and summing
up , but this would get too slow when working with more processes.
The task_alloc_security/task_free_security LSM hooks are no longer
available and maintaining a list of processes per user through the
cred_prepare/commit/free will not be accurate and with too much
overhead.
Any suggestions on how can I quickly get or maintain a list of all the
running tasks per user(or just the memory usage), without patching the
kernel would be greatly appreciated.
Best Regards,
Iliya
