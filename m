Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbZI1Bo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbZI1Bo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZI1Boz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:44:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZI1Boz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:44:55 -0400
Message-ID: <4AC01497.6030309@redhat.com>
Date: Sun, 27 Sep 2009 15:42:47 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH: kvm 4/5] Fix hotremove of CPUs for KVM.
References: <20090924151049.GB14102@amt.cnet> <1253839640-12695-1-git-send-email-zamsden@redhat.com> <1253839640-12695-2-git-send-email-zamsden@redhat.com> <1253839640-12695-3-git-send-email-zamsden@redhat.com> <1253839640-12695-4-git-send-email-zamsden@redhat.com> <1253839640-12695-5-git-send-email-zamsden@redhat.com> <4ABF2851.5090302@redhat.com>
In-Reply-To: <4ABF2851.5090302@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2009 10:54 PM, Avi Kivity wrote:
>
> First, I'm not sure per_cpu works for possible but not actual cpus.  
> Second, we now eagerly allocate but lazily free, leading to lots of 
> ifs and buts.  I think the code can be cleaner by eagerly allocating 
> and eagerly freeing.

Eager freeing requires a hotplug remove notification to the arch layer.  
I had done that originally, but not sure.

How does per_cpu() work when defined in a module anyway?  The linker 
magic going on here evades a simple one-minute analysis.

Zach
