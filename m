Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZHZNwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZHZNwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZHZNwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:52:03 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:45643 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZHZNwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:52:02 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 09:52:02 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=riyaAi3fscOdNe106aQI9aM5irs/YfRqD3Q4NNWHFfRWw4UuwGo9xW6Ww5oGG5e8Tt
         kypcpicC//XxUNBftbMSLoi8+r8Ktiu9sl4gF383CKhcEx4e7+Lp5zzOKDS4uiQvI9HZ
         JW2bkF+sPTGxuCUgbzg4onPFl1CK8qJQk66Fw=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 19:14:23 +0530
Message-ID: <e42309110908260644y65d87fc2q54405ef95be0caaf@mail.gmail.com>
Subject: sk_stream_wait_memory: Query
From: Ravish Tayal <ravish.tayal@gmail.com>
To: linux-arm@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In " tcp_sendmsg" function in 2 situation, tcp code attempts to jump
to "wait_for_memory:
" case when
1. it fails to allocate to the new skb  [sk_stream_alloc_pskb failure]
2. it fails to allocate new cache page.

and invokes the sk_stream_wait_memory function.

inside which it invokes the
  sk_wait_event(sk, &current_timeo, sk_stream_memory_free(sk) &&
vm_wait);

in case if sk_stream_wait_memory is invoked due to skb allocation
failure, it would busy loop and would not relinquish the control.
[For non-preemptive kernel]

Is it fair expectation, or even this case it should let it current
task get scheduled and re try after timer expiry.

regards
Ravish Tayal


in the case if linux kernel is configured as non-premeptive
