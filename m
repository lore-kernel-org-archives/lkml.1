Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXBMXo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXBMXo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXBMXo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:44:57 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:35496 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXBMXo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:44:57 -0500
Message-ID: <45D24D70.7070202@nortel.com>
Date: Tue, 13 Feb 2007 17:44:48 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whatever happened to down_timeout()?
References: <45D23E87.2030805@nortel.com>
In-Reply-To: <45D23E87.2030805@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2007 23:44:52.0809 (UTC) FILETIME=[F522A390:01C74FC8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> static inline int down_timeout(struct semaphore * sem, unsigned int 
> timeout)
> {
>     int ret = down_trylock(sem);
>     if (!ret)
>         ret = __down_timeout(sem, timeout);
>     return ret;
> }

Sorry, I think that should be:

static inline int down_timeout(struct semaphore * sem, unsigned int timeout)
{
	int ret = down_trylock(sem);
	if (ret)
		ret = __down_timeout(sem, timeout);
	return ret;
}

Chris
