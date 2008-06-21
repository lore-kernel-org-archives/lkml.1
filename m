Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYFUH41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYFUH41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 03:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYFUH4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 03:56:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44800 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYFUH4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 03:56:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Hz+5R+fYs4KazNS/6BmHJi87tdlfE0LYVHT1Oa2hVBcICL5ecL68uGM3iuFhG1Fs/
	p8YbY5qwmLlwPCUwiqyTw==
Message-ID: <6599ad830806210056n44c7ff37g7cd643f95aef4aa0@mail.gmail.com>
Date: Sat, 21 Jun 2008 00:56:07 -0700
From: "Paul Menage" <menage@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080616103035.788A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <6599ad830806110045n6aec52ddkfb4be91b685357fe@mail.gmail.com>
	 <20080616103035.788A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 6:32 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> honestly, I used res_counter on early version.
> but I got bad performance.

Bad performance on the charge/uncharge?

The only difference I can see is that res_counter uses
spin_lock_irqsave()/spin_unlock_irqrestore(), and you're using plain
spin_lock()/spin_unlock().

Is the overhead of a pushf/cli/popf really going to matter compared
with the overhead of forking/exiting a task?

Or approaching this from the other side, does res_counter really need
irq-safe locking, or is it just being cautious?

Paul
