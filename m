Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYLKRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYLKRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYLKRJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:09:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:8688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbYLKRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:09:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=CkUq1viP5fliwAwPDt8XcmsZjoO5shemqx714O0z/ul86lC6Cdup9ly6Yr+oH86eY
	xqFKulf7N//7fhnF2sarA==
MIME-Version: 1.0
In-Reply-To: <20081211062940.GJ3008@balbir.in.ibm.com>
References: <20081210233654.563182000@menage.corp.google.com>
	 <20081210234432.065445000@menage.corp.google.com>
	 <20081211062940.GJ3008@balbir.in.ibm.com>
Date: Thu, 11 Dec 2008 09:09:15 -0800
Message-ID: <6599ad830812110909t5e268bcak31df359c516874d1@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 10:29 PM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>
> Seems reasonable, I was wondering if instead of acquiring a mutex per
> subsystem that shares the root, if we can collapse it to a single
> mutex and prevent cgroup from changing binding. Those are
> optimizations that we can think of later

You mean a single hierarchy_mutex per root? But given that one of the
things being protected is which root you're attached to, if you're
trying to prevent hierarchy changes then which root's hierarchy_mutex
would you lock?

Paul
