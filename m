Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZLWV6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZLWV6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZLWV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:58:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35245 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130AbZLWV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:58:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=P9jWP3vNmPBGy5ysYs9OBMNufc5tPqIXtcl1W0mFjPWuJ92il17sc1AJQWNAu1ReSm
         aKrcJXcLMPx4KiXA+Hr9+NZPu7hNS35P0nfQZaDliZwet6+sjPJPl81HIbOUY8V65Quv
         tTFRIaqbI868CMq74jAJcAs3uaRE9GI3t74DQ=
MIME-Version: 1.0
Date: Wed, 23 Dec 2009 16:58:28 -0500
Message-ID: <b2f3590f0912231358g798049ey2c8012ff02a956da@mail.gmail.com>
Subject: libsas - sas_queue's policy of re-queuing all the tasks ...
From: Chetan Loke <chetanloke@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've a question regarding the libsas core.

So, sas_queue() will dispatch the coalesced tasks. It then invokes the
SAS_LLDD's execute_task. Let's assume mv_sas driver.In this case
mvs_task_exec(). Say, it received 'N' tasks the first time it was
called.However, the LLDD was only able to service M tasks(where M<N).
Now it will return rc(non-zero value). sas_queue will then requeue all
the tasks. But only (N-M) tasks should have been queued, correct? So
why are we re-trying all the tasks again?

PS - If folks are on SCST mailing list too then do not confuse this
post with my SCST post. There, the target maintainer can see if the
target driver has to worry about this.


Chetan Loke
