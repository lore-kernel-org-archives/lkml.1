Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbYENK7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbYENK7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 06:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYENK7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 06:59:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42027 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbYENK7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 06:59:45 -0400
Message-ID: <482AC60D.8020207@hp.com>
Date: Wed, 14 May 2008 06:59:25 -0400
From: Mark Seger <Mark.Seger@hp.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Shailabh Nagar <nagar@watson.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>,
       Guillaume Thouvenin <guillaume.thouvenin@bull.net>,
       Jay Lan <jlan@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: taskstats and /proc/.../io asymmetry?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you look at /proc/pid/stat, you can get the total CPU consumed by a 
process.  If you look at /proc/pid/task/tid/stat you can get the cpu 
consumed by a thread and if the tid is that of the parent you only gets 
its consumption as opposed to all its children.

I was surprised to see that the way process I/O is reported doesn't 
follow this model.  There are no /prod/pid/task/tid/io entries but 
rather you need to look in /proc/tid/io.  While I view this as a minor 
inconvenience, I can certainly live with it.  However, /proc/pid/io does 
not show the aggregate I/O numbers for the whole process and that both 
surprises and disappoints.  This means if I have a process that starts a 
bunch of worker threads that do the real work and I want to find the top 
I/O consumers I can't simply walk the /proc/pid tree but rather have to 
look at all the threads of each process and add them up.

Or am I missing something?

-mark


