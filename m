Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361Ab0ASOXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0ASOXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0ASOXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:23:30 -0500
Received: from thoth.sbs.de ([192.35.17.2]:24212 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0ASOX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:23:29 -0500
Message-ID: <4B55C05D.9000509@siemens.com>
Date: Tue, 19 Jan 2010 15:23:25 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: fix spurious interrupt with irqfd
References: <cover.1263402727.git.mst@redhat.com> <20100113171230.GB19798@redhat.com> <4B55B2B8.5090105@siemens.com> <20100119134827.GA28191@redhat.com> <4B55BBB6.2020901@siemens.com> <20100119140425.GA28410@redhat.com>
In-Reply-To: <20100119140425.GA28410@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>>>> I just wonder how broad
>>>> the impact of a broken or non-existent eventfd subsystem for kvm-kmod
>>>> is. Any thoughts welcome.
>>> How do you handle kernels that don't export eventfd_ctx_fileget?
>> Now that you mention it: not yet properly. So far we pass the file
>> struct as pseudo eventfd_ctx around on < 2.6.31. But now that I peek
>> into the struct in kvm_eventfd_ctx_remove_wait_queue, this should should
>> crash. Guess I need to look up that module the same way as I acquire
>> __wake_up_locked[_key].
> 
> This won't work that well: eventfd in upstream
> sends us POLLHUP so we can close the structure,
> in old kernels it doesn't so kernel will crash
> when we try to reference the structure later.
> 

OK, so any host kernel < 2.6.31 will never work for us. Mmh, then I
could only close the gap 2.6.31..2.6.33. vhost will show up in 33...
Will that version already be worth any eventfd wrapping?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
