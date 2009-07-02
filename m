Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZGBJck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZGBJck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZGBJcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:32:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2761 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZGBJcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:32:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=P8SUhUTWdTNy3l8nGJYLUWQw7ZeyfZSCMpA3SAMu0LsTMyTi++va7PFMPG6L5BOk8
	+CYiVDGLx2SMWgTsMY/hg==
MIME-Version: 1.0
In-Reply-To: <20090702090447.GD4305@localdomain>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021118.14469.2107.stgit@menage.mtv.corp.google.com>
	 <20090702090447.GD4305@localdomain>
Date: Thu, 2 Jul 2009 02:32:27 -0700
Message-ID: <6599ad830907020232w6c02f795k8e8a23189abc0a68@mail.gmail.com>
Subject: Re: [PATCH 5/9] [RFC] Remove cgroup_subsys.root pointer
From: Paul Menage <menage@google.com>
To: Louis.Rilling@kerlabs.com
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 2:04 AM, Louis Rilling<Louis.Rilling@kerlabs.com> wrote:
>> +/* Find the root for a given subsystem */
>> +static struct cgroupfs_root *find_root(struct cgroup_subsys *ss)
>> +{
>> +     int id = ss->subsys_id;
>> +     struct cgroupfs_root *root, *res = NULL;
>> +     for_each_root(root) {
>> +             if (root->subsys_bits && (1UL << id)) {
> Should be &, not && ------------------^^
>

Good catch. This is only used by cgroup_clone() via ns_cgroup, and I
hadn't done any testing with namespace creation and ns_cgroup.

Paul
