Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYDJScq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYDJScq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbYDJSca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbYDJSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:32:30 -0400
Message-ID: <47FE5D0D.5090404@zytor.com>
Date: Thu, 10 Apr 2008 11:31:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@osdl.org>,
       clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com> <20080410010717.GA28477@us.ibm.com> <47FD6921.6090408@zytor.com> <20080410023818.GD28477@us.ibm.com> <6599ad830804091943j1f8a4500w5eda7774adfba69f@mail.gmail.com> <20080410182616.GF28477@us.ibm.com>
In-Reply-To: <20080410182616.GF28477@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> | 
> | I thought that the consensus was that adding a new system call was
> | better than trying to force extensibility on to the existing
> | non-extensible system call.
> 
> There were couple of objections to extensible system calls like
> sys_indirect() and to Pavel's approach.
> 

This is a very different thing, though.  sys_indirect is pretty much a 
mechanism for having a sideband channel -- a second ABI -- into each and 
every system call, making it extremely hard to analyze what the full set 
of impact of a specific system call is.  Worse, as it was being proposed 
to have been used, it would have set state variables inside the kernel 
in a very opaque manner.

> | But if we are adding a new system call, why not make the new one
> | extensible to reduce the need for yet another new call in the future?
> 
> hypothetically, can we make a variant of clone() extensible to the point
> of requiring a copy_from_user() ?

The only issue is whether or not it's acceptable from a performance 
standpoint.  clone() is reasonably expensive, though.

	-hpa
