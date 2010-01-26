Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461Ab0AZCIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0AZCIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679Ab0AZCIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:08:54 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab0AZCIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:08:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Rj5T15NXWRUIJMEvM9dpt7nVsZ6usOwJU2REXwqeRTMxfyaDo0RDcVVU9txHaMV/7
	hdk2PjvoxbYC7lZOfNr2w==
MIME-Version: 1.0
In-Reply-To: <20100124232512.GA12383@linux.vnet.ibm.com>
References: <20100124232512.GA12383@linux.vnet.ibm.com>
Date: Mon, 25 Jan 2010 18:08:51 -0800
Message-ID: <6599ad831001251808k143c03fal14fe6bf5f19e0e5e@mail.gmail.com>
Subject: Re: locking design for task_subsys_state()?
From: Paul Menage <menage@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 3:25 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Is there some flag in the task structure that I should check in order to
> suppress this splat, and, more important, to document the locking
> design?  Here is what I currently have in my local tree:

Nothing cgroup-specific as far as I know - I guess it's just assumed
that since nothing else can be accessing the task_struct at that point
as it's not linked into any lists (is that correct?) then there's no
locking needed. If there's no generic task flag that indicates that
the task has never been exposed to any other thread via a list, etc,
it could be added? I imagine that some other subsystems are likely to
have similar problems. Alternatively, adding an RCU read-lock pair
around the relevant code is probably possible too, even if not
technically necessary.

Paul
