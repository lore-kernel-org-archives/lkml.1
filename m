Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYDJBOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYDJBOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 21:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYDJBOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 21:14:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYDJBOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 21:14:34 -0400
Message-ID: <47FD6921.6090408@zytor.com>
Date: Wed, 09 Apr 2008 18:10:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com> <20080410010717.GA28477@us.ibm.com>
In-Reply-To: <20080410010717.GA28477@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
>>
>> If you're going to make it a 64-bit pass it in as a 64-bit number, instead 
>> of breaking it into two numbers.
> 
> Maybe I am missing your point. The glibc interface could take a 64bit
> parameter, but don't we need to pass 32-bit values into the system call 
> on 32 bit systems ?

Not as such, no.  The ABI handles that.  To make the ABI clean on some 
architectures, it's good to consider a 64-bit value only in positions 
where they map to an even:odd register pair once slotted in.

> Yes, this was discussed before in the context of Pavel Emelyanov's patch
> 
> 	http://lkml.org/lkml/2008/1/16/109
> 
> along with sys_indirect().  While there was no consensus, it looked like
> adding a new system call was better than open ended interfaces.

That's not really an open-ended interface, it's just an expandable bitmap.

	-hpa
