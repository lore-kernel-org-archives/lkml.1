Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZA2LBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZA2LBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 06:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZA2LBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 06:01:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:31130 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZA2LBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 06:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Is2i4Zgl6ek1WM/Z9QZ+fjx4lI3g8vVe20lGmllxZERNZSw6uIr27FBNkuJ8EcWKrh
         cs3uSyYWk338yGwuLao2flj01MenN8M+TIzTfDnnWDQ4gyBa2SheKJTKpNRtknyq4zS9
         WqheDu26RJWreodLJz/2xVYURPsLykgQW3jOo=
Message-ID: <49818C7F.1030202@gmail.com>
Date: Thu, 29 Jan 2009 20:01:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: unified percpu stuff
References: <497E5F76.10301@goop.org> <497E8AD4.7030702@gmail.com> <49818842.5020004@goop.org>
In-Reply-To: <49818842.5020004@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Tejun Heo wrote:
>> The current tj-percpu[1] contains Brian's commit which consolidates
>> load_gs_base() into switch_to_new_gdt(), 
> 
> There's a bit of a bootstrap problem using switch_to_new_gdt() on the
> boot CPU: it uses smp_processor_id, which ends up doing a
> percpu_read(cpu_number), which naturally crashes because %gs isn't set
> up yet.  Perhaps switch_to_new_gdt() should take the cpu number as a
> parameter (or at least a __switch_to_new_gdt variant which does).

Please feel free to submit a patch.  It being a pretty low level
function, I think it would be better to convert it to take cpu_number.

Thanks.

-- 
tejun
