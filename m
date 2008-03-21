Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYCUPqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYCUPqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYCUPqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:46:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:32425 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYCUPqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cfStFlPo79ZQcQVF1qcTEHOw99y97Olt+Ti395iuER1JE439V2Kvr6LEHc3jVcUezUMbCOgYWFOw8u2UZhOhuTcrglxwtzQU+0FrSBqunTkeiMlCRcWqPnI2fRYLUAT53HoccW03oDV0shCDl85uuECJJ/m7IfW1Ha8h9eDdQOk=
Message-ID: <38b2ab8a0803210846p2f9b92adr951fe7fa0444de63@mail.gmail.com>
Date: Fri, 21 Mar 2008 16:46:09 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about C language.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I know it's a bit out of topic but this is something I need to clarify for
writing a Linux driver... hope you don't mind.

In my driver I have a global variable that controls a loop such as:

int my_condition;

void change_my_condition(int new)
{
    my_condition = new;
}

int foo(void)
{
    /* irqs are disabled */
    my_condition = 1;
    do {
        ....
        local_irq_enable();
        cpu_sleep();
        local_irq_disable();

   } while (my_condition);

}

This variable is modified by an interrupt handler define in another file
by using 'change_my_condition' function.

By reading the ISO C99 specification, I _think_ that I needn't any
kind of barrier
or even use the volatile type qualifier for my_condition variable to make a true
access to 'my_condition' in the controlling expression of the while, but I'm not
sure.

Coud anybody confirm ?

Thanks,
-- 
Francis
