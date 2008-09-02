Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYIBJfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYIBJfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYIBJey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:34:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:20925 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYIBJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=E+ldwjtW3PQKiaP7k0v/zIBXtYDXdPacv4Fqubyl/qDKDaiNdBt8UcQCss/6Pzxoky
         KT26OXDvTIYk+A6DW3DZ+Uzgzufc/ALcoKKt7OOWKN5xugCrhetnDcftm8+dJqEFHkRq
         Yffk/qMoUcxOQUWJnqYhiM53ePdZMbJBlyLVk=
Message-ID: <48BD08B6.4040707@tuffmail.co.uk>
Date: Tue, 02 Sep 2008 10:34:46 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jan Knutar <jknutar@nic.fi>
CC: jamagallon@ono.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Finding what is stuck...
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Knutar wrote:

> On Tuesday 02 September 2008, J.A. Magallón wrote:
>
>> I'm running 2.6.27-rc5-git2 on an Aspire One.
>> The system is in general pretty responsive, but sometimes it just
>> gets totally stuck. Even the mouse stops.
>>
>> It looks related to disk (SSD) access, but I'm not totally sure.
>
> Are you hitting swap at all? Does it have swap?
>
> On my N810 tablet there can be a huge slowdown if it starts swapping.
> The first time it dips into swap is relatively painless when stuff gets
> written out sequentially, but after that when writes are mostly random
> the throughput drops to a few kilobytes per second, causing massive
> slowdown... The MMC/SD cards hate random write, and I expect SSDs are
> no better.
>
> iostat -x -k 10
> in a terminal is useful. Check the iowait and util% numbers after/during
> slowdown...

My experience on the EeePC is similar.  I didn't look into it much but I
think it helped a lot switching to the "noop" ioscheduler

(echo noop > /sys/block/sda/queue/scheduler)

as opposed to the default CFQ, if you haven't already done so.

Alan
