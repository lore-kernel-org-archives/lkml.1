Return-Path: <linux-kernel-owner+w=401wt.eu-S1030595AbXBMAmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595AbXBMAmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030601AbXBMAmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:42:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030595AbXBMAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:42:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SDdg3ASTHrlGxS+xac3shmbyFMH8asWO4t2wbis9+EF0++Htrfw1GJ2CptFzXLfvK
	8ZW9vDuohvrqSLfXfWfCg==
Message-ID: <6599ad830702121642w80c53ddud3c77c13af99d2b7@mail.gmail.com>
Date: Mon, 12 Feb 2007 16:42:15 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [ckrm-tech] [PATCH 0/7] containers (V7): Generic Process Containers
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com
In-Reply-To: <45D1068D.4060906@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	 <45D1068D.4060906@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Sam Vilain <sam@vilain.net> wrote:
> Ask yourself this - what do you need the container structure for so
> badly, that virtualising the individual resources does not provide for?

Primarily, that otherwise every module that wants to affect/monitor
behaviour of a group of associated processes has to implement its own
process grouping abstraction.

As an example, the CPU accounting patch that in included in my patch
set as an illustration of a simple resource monitoring module is just
250 lines, almost entirely in one file; if it also had to handle
associating tasks together into groups and presenting a filesystem
interface to the user it would be far larger and would have a much
bigger footprint on the kernel.

>From the point of view of the virtual server containers, the advantage
is that you're integrated with a standard filesystem interface for
determining group membership. It does become simpler to combine
virtual servers and resource controllers, although I grant you that
you could juggle that from userspace without the additional kernel
support.

Paul
