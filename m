Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab0CJRik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:38:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38422 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab0CJRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:38:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=ULtE1KfqeO2IC52CTI/dImLFR7+ZemX48wW4IUzKfOJCg3HPmJezpk11FABlALpeM
	Y0t9HAX940HKP6O5A5sWg==
MIME-Version: 1.0
In-Reply-To: <20100310153032.GB10738@redhat.com>
References: <4B8F27BD.2020704@cn.fujitsu.com>
	 <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com>
	 <20100305141300.GA3296@redhat.com>
	 <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com>
	 <20100308230905.GB3614@redhat.com> <4B95A9C6.9060504@cn.fujitsu.com>
	 <20100309190340.GD8663@redhat.com> <4B96E8CC.9080803@cn.fujitsu.com>
	 <20100310153032.GB10738@redhat.com>
Date: Wed, 10 Mar 2010 09:38:35 -0800
Message-ID: <1786ab031003100938x19e7c054ieba6c34ebd939ad6@mail.gmail.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface "weight_device" 
	for IO-Controller
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Nauman Rafique <nauman@google.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> This still leaves the issue of reaching a gendisk object from request
> queue. Looking into it.

It looks like we have that pairing way back in blk_register_queue()
which takes a gendisk.  Is there any reason we don't hold onto the
gendisk there?  Eyeballing add_disk() and unlink_gendisk() seems to
confirm that gendisk lifetime spans request_queue.

Nauman and I were also wondering why blkio_group and blkio_policy_node
store a dev_t, rather than a direct pointer to gendisk.  dev_t seems
more like a userspace<->kernel interface than an inside-the-kernel
interface.

Chad
