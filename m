Return-Path: <linux-kernel-owner+w=401wt.eu-S1762577AbYBWUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762577AbYBWUhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYBWUhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:37:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYBWUhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:37:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oB/PdT9qV12RSXLxtaPHIsVrJlXwNln4AaH0txqCf66nD+7OwC0ADW0yVjrsO3Cu8
	c4XOTln1Lb3as3GW/Owiw==
Message-ID: <6599ad830802231236s5b633290x2199323ffcf8e5cf@mail.gmail.com>
Date: Sat, 23 Feb 2008 12:36:59 -0800
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/8] sched: rt-group: interface
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com
In-Reply-To: <1203798389.6242.98.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080204210258.118479000@chello.nl>
	 <20080204211836.968632000@chello.nl>
	 <6599ad830802231148w518d937cyd75d1d0a35702d9d@mail.gmail.com>
	 <1203796668.6242.82.camel@lappy>
	 <6599ad830802231202q6584557fte44f4976eacc6e89@mail.gmail.com>
	 <1203798389.6242.98.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:26 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>  > In that case I guess I'll have to add signed versions of the
>  > read_uint/write_uint methods.
>
>  Yes, I looked at that, I found the interface somewhat unfortunate, it
>  would mean growing the struct with two more function pointers.

Is that really a big deal? We're talking about a structure that has a
small number (<10 in the current tree) of instances per cgroup
subsystem.

> Perhaps a
>  read and write function with abstract data would be better suited. That
>  would allow for this and more. Sadly it looses type information.

If the size of the struct cftype really became a problem, I think the
cleanest way to fix it would be to have a union of the potential
function pointers, and add a field to specify which one is in use.

Paul
