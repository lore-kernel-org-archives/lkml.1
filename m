Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZLBMgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZLBMgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZLBMgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:36:52 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:44121 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZLBMgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:36:52 -0500
Message-ID: <4B165F68.70605@ladisch.de>
Date: Wed, 02 Dec 2009 13:36:56 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mai Daftedar <mai.daftedar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Inter Thread Coomunication
References: <2cd4ff050912020417r27b52a89v4e676c7d4ab74ad4@mail.gmail.com>
In-Reply-To: <2cd4ff050912020417r27b52a89v4e676c7d4ab74ad4@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mai Daftedar wrote:
>    I have a question to ask I have two threads that have
> messages(Structure with data) that should be passed between them.
> After some googling I learnt that using queues and pipes are expensive
> (effieciency wise) and that I should just pass in the parameters and
> use mutex to protect shared data...

What is expensive is not necessarily the copying of the data into and
out of the pipe (this depends on the amount of data), but the system
calls necessary for this.  If your threads use mutexes to wait for the
data, you have system calls anyway (actually going to sleep and waking
up cannot be handled in userspace), so there might not be any difference
one way or the other.  The only way to find out is to test both
mechanisms.


HTH
Clemens
