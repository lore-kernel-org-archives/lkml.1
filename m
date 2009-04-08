Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbZDHG03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbZDHG03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762163AbZDHG0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:26:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZDHG0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:26:08 -0400
Message-ID: <49DC436C.2050309@zytor.com>
Date: Tue, 07 Apr 2009 23:25:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do not keep interrupt window closed by sti in real mode
References: <1239161017-7398-1-git-send-email-glommer@redhat.com> <49DC24C2.7000608@zytor.com> <49DC39EE.1070606@redhat.com>
In-Reply-To: <49DC39EE.1070606@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
> I'm guessing the problem is due to the second instruction.  We don't
> clear the 'blocked by interrupt shadow' flag when we emulate, which
> extends interrupt shadow by one more instruction.  If the instruction
> sequence is 'sti hlt' we end in an inconsistent state.
> 

Ah, and since we're in real mode, we have to emulate everything (at
least on some hardware), right?  So we really do need to clear the
interrupt shadow bit in the interpreter... I don't see a way around that.

Otherwise not just STI but MOV SS shadows will break, and in real mode
MOV SS shadow is crucial.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

