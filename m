Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZAMLJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZAMLJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZAMLJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:09:39 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:48414 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZAMLJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:09:38 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 06:09:38 EST
Message-ID: <496C73DE.3030600@wpkg.org>
Date: Tue, 13 Jan 2009 11:58:38 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, zbr@ioremap.net
Subject: Re: Linux killed Kenny, bastard!
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:
>> 
>> > Like anything that spawns a thread or process per request/client, or
>> > preallocates set of them which connect to the huge object like database.
>> > Most of the time database/server is killed first instead of comparably
>> > small clients.
>> 
>> No, the reverse is true: when a task is chosen for oom kill based on the 
>> badness heuristic, the oom killer first attempts to kill any child task 
>> that isn't attached to the same mm.  If the child shares an mm, both tasks 
>> must die before memory freeing can occur.
> 
> It is a theory, not a practice. OOM-killer most of time starts from ssh,
> database and lighttpd on the tested machines, when it could start in
> the reverse order and do not touch ssh at all. Better not from daemon
> itself, but its fastcgi spawned processes.

How does this feature relate to:

config ANDROID_LOW_MEMORY_KILLER
         bool "Android Low Memory Killer"
         default N
         ---help---
           Register processes to be killed when memory is low

available in Staging drivers / Android?


-- 
Tomasz Chmielewski
http://wpkg.org

