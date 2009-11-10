Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZKJAee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZKJAee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZKJAee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:34:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbZKJAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:34:33 -0500
Message-ID: <4AF8B4FF.9050405@zytor.com>
Date: Mon, 09 Nov 2009 16:34:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: linux-kernel@vger.kernel.org, device@lanana.org, akpm@linux-foundation.org,
       rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com> <1257813017-28598-2-git-send-email-cascardo@holoscopio.com> <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 04:30 PM, Thadeu Lima de Souza Cascardo wrote:
> The current dynamic allocation of minor number for misc devices has some
> drawbacks.
> 
> First of all, the range for dynamic numbers include some statically
> allocated numbers. It goes from 63 to 0, and we have numbers in the
> range from 1 to 15 already allocated. Although, it gives priority to the
> higher and not allocated numbers, we may end up in a situation where we
> must reject registering a driver which got a static number because a
> driver got its number with dynamic allocation. Considering fs/dlm/user.c
> allocates as many misc devices as lockspaces are created, and that we
> have more than 50 users around, it's not unreasonable to reach that
> situation.
> 
> The proposed solution uses the not yet reserved range from 64 to 127. If
> more devices are needed, we may push 64 to 16.
> 

Again, why not push these up above 256?

	-hpa
