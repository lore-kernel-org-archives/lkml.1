Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbZIHQry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbZIHQry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZIHQrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZIHQrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:47:53 -0400
Message-ID: <4AA68AA5.10505@redhat.com>
Date: Tue, 08 Sep 2009 12:47:33 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Nauman Rafique <nauman@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com
Subject: Re: Regarding dm-ioband tests
References: <20090904231129.GA3689@redhat.com>	 <20090907.200222.193693062.ryov@valinux.co.jp>	 <4AA51065.6050000@redhat.com>	 <20090908.120119.71095369.ryov@valinux.co.jp>	 <20090908134244.GA15974@redhat.com> <e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
In-Reply-To: <e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nauman Rafique wrote:

> I think this is probably the key deal breaker. dm-ioband has no
> mechanism to anticipate or idle for a reader task. Without such a
> mechanism, a proportional division scheme cannot work for tasks doing
> reads. 

That is a really big issue, since most reads tend to be synchronous
(the application is waiting for the read), while many writes are not
(the application is doing something else while the data is written).

Having writes take precedence over reads will really screw over the
readers, while not benefitting the writers all that much.

-- 
All rights reversed.
