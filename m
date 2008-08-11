Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYHKQCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYHKQCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHKQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:02:35 -0400
Received: from gw.goop.org ([64.81.55.164]:49897 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYHKQCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:02:34 -0400
Message-ID: <48A06287.8020906@goop.org>
Date: Mon, 11 Aug 2008 09:02:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: Gerd Hoffmann <kraxel@redhat.com>, Avi Kivity <avi@qumranet.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Use of barriers in pvclock ABI
References: <489CA3DA.1090400@goop.org> <489FE56E.1080707@redhat.com> <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
In-Reply-To: <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Okay for guest vcpu, but what about physical cpus?
>
> IIRC, the checks are there, and so strict, to account for the
> possiblity of the vcpu to be migrated to another cpu in the middle of
> the
> clock reading.
>   

That's fine.  As part of rescheduling a vcpu on a new pcpu, the clock 
record will be updated with the new cpu's parameters, but that update 
will be complete by the time the vcpu gets rescheduled.  The version 
check and loop still needs to be there, but it will never see an 
inconsistent (partially updated) clock record.

    J
