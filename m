Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZG2ABD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZG2ABD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZG2ABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:01:00 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:39983 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZG2AA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pN2EX4hZl5RAaPVM1PxGw7FhKJELYuShyrj3O/mXlmt5lEpjmT7CVL1JwWym8qWYBu
         KaX3L2HFCIjSw9WaIOADNlOBhFgoF0zhq6omgQRgtob9R4O4VLmIdogOx2+ypPyEa5AO
         a4pXzuK7a8vDk0OxoGOllRW2ocX5RJMkosBOc=
MIME-Version: 1.0
In-Reply-To: <20090728165245.65d5cb23.akpm@linux-foundation.org>
References: <4A693122.6060503@gmail.com>
	 <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
	 <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com>
	 <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com>
	 <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com>
	 <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com>
	 <4A6F2AF4.6050505@gmail.com>
	 <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
	 <4A6F8115.7000500@gmail.com>
	 <20090728165245.65d5cb23.akpm@linux-foundation.org>
Date: Tue, 28 Jul 2009 17:00:54 -0700
Message-ID: <7928e7bd0907281700s13d9937yc3b2933b13cfae9f@mail.gmail.com>
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped 
	vma clearing
From: Moussa Ba <moussa.a.ba@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com,
       xiyou.wangcong@gmail.com, adobriyan@gmail.com, mpm@selenic.com,
       mel@csn.ul.ie, yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch makes the clear_refs more versatile in adding the option to
select anonymous pages or file backed pages for clearing.  This
addition has a measurable impact on user space application performance
as it decreases the number of pagewalks in scenarios where one is only
interested in a specific type of page (anonymous or file mapped).


On Tue, Jul 28, 2009 at 4:52 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Tue, 28 Jul 2009 15:52:05 -0700
> "Moussa A. Ba" <moussa.a.ba@gmail.com> wrote:
>
>> This patch adds anonymous and file backed filters to the clear_refs interface.
>> echo 1 > /proc/PID/clear_refs resets the bits on all pages
>> echo 2 > /proc/PID/clear_refs resets the bits on anonymous pages only
>> echo 3 > /proc/PID/clear_refs resets the bits on file backed pages only
>> Any other value is ignored
>
> The changelog is missing any rationale for making this change.
> Originally we were told that it "makes the clear_refs proc interface a
> bit more versatile", but that's a bit thin.
>
> How do we justify making this change to Linux?  What value does it
> have?  Can you describe a usage scenario which would help people
> understand the usefulness of the change?
>
> Thanks.
>
