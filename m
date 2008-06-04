Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYFDJQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYFDJQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYFDJPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:15:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFDJPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:15:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=AJtlDpWhhrPANLrobAegKbZtE0jt8d9wqND2OXpiVAcliAWUHC1J0tUK1vyc88V7i
	0GcxgPt0Ujn0affDnAUOQ==
Message-ID: <6599ad830806040215j4f49483bnfa474eb27120a5e3@mail.gmail.com>
Date: Wed, 4 Jun 2008 02:15:32 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/2] memcg: hierarchy support (v3)
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
In-Reply-To: <20080604181528.f4c94743.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830806040159o648392a1l3dbd84d9c765a847@mail.gmail.com>
	 <20080604181528.f4c94743.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 2:15 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Should we try to support hierarchy and non-hierarchy cgroups in the
>> same tree? Maybe we should just enforce the restrictions that:
>>
>> - the hierarchy mode can't be changed on a cgroup if you have children
>> or any non-zero usage/limit
>> - a cgroup inherits its parent's hierarchy mode.
>>
> Ah, my patch does it (I think).  explanation is bad.
>
> - mem cgroup's mode can be changed against ROOT node which has no children.
> - a child inherits parent's mode.

But if it can only be changed for the root cgroup when it has no
children, than implies that all cgroups must have the same mode. I'm
suggesting that we allow non-root cgroups to change their mode, as
long as:

- they have no children

- they don't have any limit charged to their parent (which means that
either they have a zero limit, or they have no parent, or they're not
in hierarchy mode)

Paul
