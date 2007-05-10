Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbXEJFrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbXEJFrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXEJFq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:46:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:33843 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbXEJFqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MyhT9eOd4Pjd3Oe929wEOLtLd8bGfsK6LVRqJa3K7ykmB2nzfVahIT6QdR6ep0NRpI11SR8/MjrKAOaGhdo3KYxoygN3ex4+N2t9tvV22iZqUfGuISaOCxtjVRtSNDara9EqYyefkePhF4d097dEuxmq6U+BKNmaFS7rQn4KOrs=
Message-ID: <e810d8480705092246k1bb9afe6ma253fd7679f5031a@mail.gmail.com>
Date: Thu, 10 May 2007 13:46:53 +0800
From: "Quan Sun" <cfk.quan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Different scheduler behavior between 2.4 and 2.6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  Recently I met a problem on different scheduler behavior between
2.4.22 and 2.6.18.8.
  The application works as a proxy, it listen on an interface,
connect through another interface. This application works on a box
with two Xeon cpu, each of them is hyper-threading.
  On 2.4.22, CPU0 serve interrupts, the application works on other
three CPUs.
  But on 2.6.18.8, if I turn on 'noirqbalance' kernel parameter, and no
irqbalance  process, the application will stuck to CPU0 as well as interrupts
after several seconds' working. Then there will be a 0% idle cpu, and
three 100%idle CPUs.

 /proc/interrupt shows all eths's interrupts are working at CPU0.

 It seems that scheduler ignores the working load of interrupts.

  My question is, is there a way to tune 2.6 kernel working as 2.4?
Just one cpu for interrupts, other three cpu for normal work.

-- 
Quan Sun
