Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZKRPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZKRPXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZKRPXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:23:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbZKRPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:23:16 -0500
Message-ID: <4B041143.2080407@redhat.com>
Date: Wed, 18 Nov 2009 10:22:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Merillat <dan.merillat@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
In-Reply-To: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 02:56 AM, Dan Merillat wrote:
> 1.7gb of disk cache, 750 meg of free RAM, and it swaps out 300meg in a
> matter of seconds when given access to a swapfile, then thrashes the
> disk like crazy because that RAM was actively in use.
>    

> Ideas on where to start looking?  If this is a vmware issue I'll take
> it to them.
>    
This smells like a higher order memory allocation
failed and either is doing a lot of direct reclaim or
kicked kswapd until it freed up lots of memory.

However, I do not believe we keep track of higher
order reclaims in /proc/vmstat or elsewhere I
looked :(
