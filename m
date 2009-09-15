Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZIOFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZIOFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 01:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZIOFzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 01:55:43 -0400
Received: from chello212186124096.11.vie.surfer.at ([212.186.124.96]:56296
	"EHLO wiesinger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbZIOFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 01:55:42 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 01:55:42 EDT
Date: Tue, 15 Sep 2009 07:48:54 +0200 (CEST)
From: Gerhard Wiesinger <lists@wiesinger.com>
To: linux-kernel@vger.kernel.org
Subject: Moxa Driver Update to 2.6.30
Message-ID: <alpine.LFD.2.00.0909150738590.29043@bbs.intern>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-MailScanner-Information-wiesinger-com: Please contact the ISP for more information
X-wiesinger-com-MailScanner-ID: n8F5mtOY030726
X-MailScanner-wiesinger-com: Found to be clean
X-MailScanner-SpamCheck-wiesinger-com: not spam, SpamAssassin (not cached,
	score=-4.399, required 4.5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: lists@wiesinger.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In Kernel 2.6.29 the moxa 5110 driver compiled well. In 2.6.30 some 
deprecated definitions have been removed.

/usr/src/kernels/2.6.29.6-217.2.16.fc11.x86_64/include/linux/sched.h:
struct signal_struct {

         union {
                 pid_t session __deprecated;
                 pid_t __session;
         };

static inline pid_t task_session_nr(struct task_struct *tsk)
{
         return tsk->signal->__session;
}

Code is used in the way:
npreal2.h:
#if (LINUX_VERSION_CODE >= VERSION_CODE(2,6,5))
#if (LINUX_VERSION_CODE >= VERSION_CODE(2,6,20))
#if (LINUX_VERSION_CODE >= VERSION_CODE(2,6,26))
#define MX_SESSION()    task_session_nr(current)
#else
#define MX_SESSION()    (pid_t)tty->session
#endif
#else
#define MX_SESSION()    current->signal->session
#endif
#else
#define MX_SESSION()    current->session
#endif

What's the correct change for the definition of MX_SESSION in 2.6.30?
(Didn't find any useful replacement)

Moxa driver files source files can be found at:
http://www.moxa.com/drivers/DN_Driver/Linux/npreal2_1.16_Build_09030513.tgz

Thnx.

Ciao,
Gerhard

--
http://www.wiesinger.com/
