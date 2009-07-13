Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZGMXfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZGMXfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZGMXfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:35:12 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:47402 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZGMXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Rxr0lNq3fy96eNCCNSulE5jhAyFmTLYWTSVxQV51d0dsJ9m91F9eNN0h0o8U3pAhp+
         fl1olbHg7LiAxDXSmjJCo+NkZdhsKkumavA6LYJHmBhX9I04qo2AIMsrmqsXQPGDGRxI
         NxExWgeDosqv/xasgXld4ixJvJC05v3unF3Lk=
Message-ID: <4A5BC50D.9020102@gmail.com>
Date: Mon, 13 Jul 2009 17:36:45 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Floppy constantly accessed in 2.6.31-rc2
References: <h3ehgd$mti$1@ger.gmane.org> <1247526411.5220.5.camel@localhost.localdomain>
In-Reply-To: <1247526411.5220.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 05:06 PM, Paul Bolle wrote:
> On Sun, 2009-07-12 at 23:44 -0600, Robert Hancock wrote:
>> On 2.6.31-rc2 (actually current git as of today) the floppy drive is
>> constantly being accessed with these messages being reported:
>>
>> Platform driver 'floppy' needs updating - please use dev_pm_ops
>> Floppy drive(s): fd0 is 1.44M
>> FDC 0 is a post-1991 82077
>> end_request: I/O error, dev fd0, sector 0
>> end_request: I/O error, dev fd0, sector 0
>> end_request: I/O error, dev fd0, sector 0
>> end_request: I/O error, dev fd0, sector 0
>> end_request: I/O error, dev fd0, sector 0
>> end_request: I/O error, dev fd0, sector 0
>> end_request: I/O error, dev fd0, sector 0
>>
>> lsof reports no process with /dev/fd0 open so it is not clear what is
>> causing this activity. It looks like the access starts when I log in to
>> X, but doesn't stop when I log out. I'm guessing HAL or something checks
>> the floppy drive and then the kernel somehow gets stuck in a loop
>> retrying the request..
>
> That does look a bit like
> https://bugzilla.redhat.com/show_bug.cgi?id=489083 (and its duplicate
> https://bugzilla.redhat.com/show_bug.cgi?id=496586 ).

Indeed, it is.. It looks like in 2.6.29.5 the floppy module isn't being 
autoloaded and in 2.6.31-rc2 it is, which causes the DeviceKit bug to 
show up. Updating DeviceKit seems to fix the problem.

So, not a kernel regression.
