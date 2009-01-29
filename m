Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZA2Kn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZA2Kn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZA2KnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:43:17 -0500
Received: from gw.goop.org ([64.81.55.164]:41122 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbZA2KnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:43:16 -0500
Message-ID: <49818842.5020004@goop.org>
Date: Thu, 29 Jan 2009 02:43:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: unified percpu stuff
References: <497E5F76.10301@goop.org> <497E8AD4.7030702@gmail.com>
In-Reply-To: <497E8AD4.7030702@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> The current tj-percpu[1] contains Brian's commit which consolidates
> load_gs_base() into switch_to_new_gdt(), 

There's a bit of a bootstrap problem using switch_to_new_gdt() on the 
boot CPU: it uses smp_processor_id, which ends up doing a 
percpu_read(cpu_number), which naturally crashes because %gs isn't set 
up yet.  Perhaps switch_to_new_gdt() should take the cpu number as a 
parameter (or at least a __switch_to_new_gdt variant which does).

    J

