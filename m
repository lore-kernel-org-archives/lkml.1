Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbXFVPkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbXFVPkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbXFVPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:40:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbXFVPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:40:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PPN+BQ4qm4I6p5GpTs/SddPVLNLnzPabmmmKqBnUV4LfN814SR6F0CJbX+i+48gLV
	MjEUYWnGltu4pbF5KWbIA==
Message-ID: <6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>
Date: Fri, 22 Jun 2007 08:39:50 -0700
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelianov" <xemul@openvz.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <467B2F4F.2030101@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
	 <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
	 <467B2F4F.2030101@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Pavel Emelianov <xemul@openvz.org> wrote:
>
> Nothing wrong, but currently they are shown in "natural" points, i.e. in
> those that the controller accounts them in. For RSS controller the natural
> point is "page", but auto-converting them from pages to bytes is wrong, as
> not all the controllers account in pages.

This exposes more implementation detail than I think is good.
Something like a memory controller should use a more abstract
interface like bytes, and do the conversion to/from its internal
"natural" units like pages internally. E.g. the example cpu accounting
controller that I included with my patch set reports usage in
milliseconds, even though it counts internally in jiffies.

Paul
