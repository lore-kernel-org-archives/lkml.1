Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbXFKRrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbXFKRrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXFKRrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:47:15 -0400
Received: from mail.suse.de ([195.135.220.2]:57764 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXFKRrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:47:13 -0400
Date: Mon, 11 Jun 2007 19:47:06 +0200
From: Karsten Keil <kkeil@suse.de>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: Andi Drebes <lists-receive@programmierforen.de>,
       Jan-Benedict Glaw <jbglaw@lug-owl.de>, kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [KJ] Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Message-ID: <20070611174706.GA9150@pingi.kke.suse.de>
Mail-Followup-To: Darren Jenkins <darrenrjenkins@gmail.com>,
	Andi Drebes <lists-receive@programmierforen.de>,
	Jan-Benedict Glaw <jbglaw@lug-owl.de>,
	kernel-janitors@lists.osdl.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200706101235.09578.lists-receive@programmierforen.de> <20070610131122.GB3588@pingi.kke.suse.de> <20070610131402.GR2649@lug-owl.de> <200706111120.07730.lists-receive@programmierforen.de> <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 10:25:31PM +1000, Darren Jenkins wrote:
> G'day Andi,
> 
> On 6/11/07, Andi Drebes <lists-receive@programmierforen.de> wrote:
> 
> >> I'd suggest to not use another define, but use ARRAY_SIZE(foo)
> >> _instead of_ eg. FNCOUNT.
> >I thought of this, too, but I tried to keep things consistent. Let me
> >explain that a little bit more in detail. If you have a look at the files
> >in drivers/isdn/hisax then you will see that a lot of array size 
> >definitions
> >are assigned to preprocessor macros. So I thought removing just one
> >of the macros while the other continue to exist would make the code
> >a little bit more inconsistent. However, one might disagree about that.
> >So here's another patch that includes the changes from the original patch
> >and removes the FNCOUNT preprocessor definition. Perhaps the original
> >authors of the files should decide wether they want to keep it or not.
> 
> I think what was meant here was to remove _all_ the macros that you
> assigned to the ARRAY_SIZE() macro.
> 
...

Agree, here is a new version.

This patch replaces various array size calculations in drivers/isdn/hisax
done using sizeof with the ARRAY_SIZE macro.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
 drivers/isdn/hisax/callc.c   |    4 +--
 drivers/isdn/hisax/isdnl1.c  |   12 ++-----
 drivers/isdn/hisax/isdnl2.c  |    4 +--
 drivers/isdn/hisax/isdnl3.c  |    4 +--
 drivers/isdn/hisax/l3_1tr6.c |   20 +++--------
 drivers/isdn/hisax/l3dss1.c  |   26 ++++----------
 drivers/isdn/hisax/l3ni1.c   |   24 ++++---------
 drivers/isdn/hisax/q931.c    |   77 ++++++++++++++---------------------------
 drivers/isdn/hisax/tei.c     |    4 +--
 9 files changed, 55 insertions(+), 120 deletions(-)

diff --git a/drivers/isdn/hisax/callc.c b/drivers/isdn/hisax/callc.c
index 7c56c44..0b9ed8e 100644
--- a/drivers/isdn/hisax/callc.c
+++ b/drivers/isdn/hisax/callc.c
@@ -834,8 +834,6 @@ static struct FsmNode fnlist[] __initdata =
 };
 /* *INDENT-ON* */
 
-#define FNCOUNT (sizeof(fnlist)/sizeof(struct FsmNode))
-
 int __init
 CallcNew(void)
 {
@@ -843,7 +841,7 @@ CallcNew(void)
 	callcfsm.event_count = EVENT_COUNT;
 	callcfsm.strEvent = strEvent;
 	callcfsm.strState = strState;
-	return FsmNew(&callcfsm, fnlist, FNCOUNT);
+	return FsmNew(&callcfsm, fnlist, ARRAY_SIZE(fnlist));
 }
 
 void
diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
index a14204e..80e923e 100644
--- a/drivers/isdn/hisax/isdnl1.c
+++ b/drivers/isdn/hisax/isdnl1.c
@@ -647,8 +647,6 @@ static struct FsmNode L1SFnList[] __initdata =
 	{ST_L1_F8, EV_TIMER_DEACT, l1_timer_deact},
 };
 
-#define L1S_FN_COUNT (sizeof(L1SFnList)/sizeof(struct FsmNode))
-
 #ifdef HISAX_UINTERFACE
 static void
 l1_deact_req_u(struct FsmInst *fi, int event, void *arg)
@@ -706,8 +704,6 @@ static struct FsmNode L1UFnList[] __initdata =
 	{ST_L1_RESET, EV_TIMER_DEACT, l1_timer_deact},
 };
 
-#define L1U_FN_COUNT (sizeof(L1UFnList)/sizeof(struct FsmNode))
-
 #endif
 
 static void
@@ -754,8 +750,6 @@ static struct FsmNode L1BFnList[] __initdata =
 	{ST_L1_WAIT_DEACT, EV_TIMER_DEACT, l1b_timer_deact},
 };
 
-#define L1B_FN_COUNT (sizeof(L1BFnList)/sizeof(struct FsmNode))
-
 int __init 
 Isdnl1New(void)
 {
@@ -765,7 +759,7 @@ Isdnl1New(void)
 	l1fsm_s.event_count = L1_EVENT_COUNT;
 	l1fsm_s.strEvent = strL1Event;
 	l1fsm_s.strState = strL1SState;
-	retval = FsmNew(&l1fsm_s, L1SFnList, L1S_FN_COUNT);
+	retval = FsmNew(&l1fsm_s, L1SFnList, ARRAY_SIZE(L1SFnList));
 	if (retval)
 		return retval;
 
@@ -773,7 +767,7 @@ Isdnl1New(void)
 	l1fsm_b.event_count = L1_EVENT_COUNT;
 	l1fsm_b.strEvent = strL1Event;
 	l1fsm_b.strState = strL1BState;
-	retval = FsmNew(&l1fsm_b, L1BFnList, L1B_FN_COUNT);
+	retval = FsmNew(&l1fsm_b, L1BFnList, ARRAY_SIZE(L1BFnList));
 	if (retval) {
 		FsmFree(&l1fsm_s);
 		return retval;
@@ -783,7 +777,7 @@ Isdnl1New(void)
 	l1fsm_u.event_count = L1_EVENT_COUNT;
 	l1fsm_u.strEvent = strL1Event;
 	l1fsm_u.strState = strL1UState;
-	retval = FsmNew(&l1fsm_u, L1UFnList, L1U_FN_COUNT);
+	retval = FsmNew(&l1fsm_u, L1UFnList, ARRAY_SIZE(L1UFnList));
 	if (retval) {
 		FsmFree(&l1fsm_s);
 		FsmFree(&l1fsm_b);
diff --git a/drivers/isdn/hisax/isdnl2.c b/drivers/isdn/hisax/isdnl2.c
index 3446f24..7b9496a 100644
--- a/drivers/isdn/hisax/isdnl2.c
+++ b/drivers/isdn/hisax/isdnl2.c
@@ -1623,8 +1623,6 @@ static struct FsmNode L2FnList[] __initdata =
 	{ST_L2_8, EV_L1_DEACTIVATE, l2_persistent_da},
 };
 
-#define L2_FN_COUNT (sizeof(L2FnList)/sizeof(struct FsmNode))
-
 static void
 isdnl2_l1l2(struct PStack *st, int pr, void *arg)
 {
@@ -1836,7 +1834,7 @@ Isdnl2New(void)
 	l2fsm.event_count = L2_EVENT_COUNT;
 	l2fsm.strEvent = strL2Event;
 	l2fsm.strState = strL2State;
-	return FsmNew(&l2fsm, L2FnList, L2_FN_COUNT);
+	return FsmNew(&l2fsm, L2FnList, ARRAY_SIZE(L2FnList));
 }
 
 void
diff --git a/drivers/isdn/hisax/isdnl3.c b/drivers/isdn/hisax/isdnl3.c
index 935f233..0676602 100644
--- a/drivers/isdn/hisax/isdnl3.c
+++ b/drivers/isdn/hisax/isdnl3.c
@@ -543,8 +543,6 @@ static struct FsmNode L3FnList[] __initdata =
 };
 /* *INDENT-ON* */
 
-#define L3_FN_COUNT (sizeof(L3FnList)/sizeof(struct FsmNode))
-
 void
 l3_msg(struct PStack *st, int pr, void *arg)
 {
@@ -587,7 +585,7 @@ Isdnl3New(void)
 	l3fsm.event_count = L3_EVENT_COUNT;
 	l3fsm.strEvent = strL3Event;
 	l3fsm.strState = strL3State;
-	return FsmNew(&l3fsm, L3FnList, L3_FN_COUNT);
+	return FsmNew(&l3fsm, L3FnList, ARRAY_SIZE(L3FnList));
 }
 
 void
diff --git a/drivers/isdn/hisax/l3_1tr6.c b/drivers/isdn/hisax/l3_1tr6.c
index c5c36ee..b0554f8 100644
--- a/drivers/isdn/hisax/l3_1tr6.c
+++ b/drivers/isdn/hisax/l3_1tr6.c
@@ -698,9 +698,6 @@ static struct stateentry downstl[] =
 	 CC_T308_2, l3_1tr6_t308_2},
 };
 
-#define DOWNSTL_LEN \
-	(sizeof(downstl) / sizeof(struct stateentry))
-
 static struct stateentry datastln1[] =
 {
 	{SBIT(0),
@@ -735,9 +732,6 @@ static struct stateentry datastln1[] =
 	 MT_N1_REL_ACK, l3_1tr6_rel_ack}
 };
 
-#define DATASTLN1_LEN \
-	(sizeof(datastln1) / sizeof(struct stateentry))
-
 static struct stateentry manstatelist[] =
 {
         {SBIT(2),
@@ -746,8 +740,6 @@ static struct stateentry manstatelist[] =
          DL_RELEASE | INDICATION, l3_1tr6_dl_release},
 };
  
-#define MANSLLEN \
-        (sizeof(manstatelist) / sizeof(struct stateentry))
 /* *INDENT-ON* */
 
 static void
@@ -840,11 +832,11 @@ up1tr6(struct PStack *st, int pr, void *arg)
 				mt = MT_N1_INVALID;
 			}
 		}
-		for (i = 0; i < DATASTLN1_LEN; i++)
+		for (i = 0; i < ARRAY_SIZE(datastln1); i++)
 			if ((mt == datastln1[i].primitive) &&
 			    ((1 << proc->state) & datastln1[i].state))
 				break;
-		if (i == DATASTLN1_LEN) {
+		if (i == ARRAY_SIZE(datastln1)) {
 			dev_kfree_skb(skb);
 			if (st->l3.debug & L3_DEB_STATE) {
 				sprintf(tmp, "up1tr6%sstate %d mt %x unhandled",
@@ -892,11 +884,11 @@ down1tr6(struct PStack *st, int pr, void *arg)
 		proc = arg;
 	}
 
-	for (i = 0; i < DOWNSTL_LEN; i++)
+	for (i = 0; i < ARRAY_SIZE(downstl); i++)
 		if ((pr == downstl[i].primitive) &&
 		    ((1 << proc->state) & downstl[i].state))
 			break;
-	if (i == DOWNSTL_LEN) {
+	if (i == ARRAY_SIZE(downstl)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			sprintf(tmp, "down1tr6 state %d prim %d unhandled",
 				proc->state, pr);
@@ -922,11 +914,11 @@ man1tr6(struct PStack *st, int pr, void *arg)
                 printk(KERN_ERR "HiSax man1tr6 without proc pr=%04x\n", pr);
                 return;
         }
-        for (i = 0; i < MANSLLEN; i++)
+        for (i = 0; i < ARRAY_SIZE(manstatelist); i++)
                 if ((pr == manstatelist[i].primitive) &&
                     ((1 << proc->state) & manstatelist[i].state))
                         break;
-        if (i == MANSLLEN) {
+        if (i == ARRAY_SIZE(manstatelist)) {
                 if (st->l3.debug & L3_DEB_STATE) {
                         l3_debug(st, "cr %d man1tr6 state %d prim %d unhandled",
                                 proc->callref & 0x7f, proc->state, pr);
diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
index 99feae8..a12fa4d 100644
--- a/drivers/isdn/hisax/l3dss1.c
+++ b/drivers/isdn/hisax/l3dss1.c
@@ -2820,9 +2820,6 @@ static struct stateentry downstatelist[] =
 	 CC_T309, l3dss1_dl_release},
 };
 
-#define DOWNSLLEN \
-	(sizeof(downstatelist) / sizeof(struct stateentry))
-
 static struct stateentry datastatelist[] =
 {
 	{ALL_STATES,
@@ -2875,9 +2872,6 @@ static struct stateentry datastatelist[] =
 	 MT_RESUME_REJECT, l3dss1_resume_rej},
 };
 
-#define DATASLLEN \
-	(sizeof(datastatelist) / sizeof(struct stateentry))
-
 static struct stateentry globalmes_list[] =
 {
 	{ALL_STATES,
@@ -2888,8 +2882,6 @@ static struct stateentry globalmes_list[] =
 	 MT_RESTART_ACKNOWLEDGE, l3dss1_restart_ack},
 */
 };
-#define GLOBALM_LEN \
-	(sizeof(globalmes_list) / sizeof(struct stateentry))
 
 static struct stateentry manstatelist[] =
 {
@@ -2903,8 +2895,6 @@ static struct stateentry manstatelist[] =
          DL_RELEASE | INDICATION, l3dss1_dl_release},
 };
 
-#define MANSLLEN \
-        (sizeof(manstatelist) / sizeof(struct stateentry))
 /* *INDENT-ON* */
 
 
@@ -2918,11 +2908,11 @@ global_handler(struct PStack *st, int mt, struct sk_buff *skb)
 	struct l3_process *proc = st->l3.global;
 
 	proc->callref = skb->data[2]; /* cr flag */
-	for (i = 0; i < GLOBALM_LEN; i++)
+	for (i = 0; i < ARRAY_SIZE(globalmes_list); i++)
 		if ((mt == globalmes_list[i].primitive) &&
 		    ((1 << proc->state) & globalmes_list[i].state))
 			break;
-	if (i == GLOBALM_LEN) {
+	if (i == ARRAY_SIZE(globalmes_list)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			l3_debug(st, "dss1 global state %d mt %x unhandled",
 				proc->state, mt);
@@ -3097,11 +3087,11 @@ dss1up(struct PStack *st, int pr, void *arg)
 	}
 	if ((p = findie(skb->data, skb->len, IE_DISPLAY, 0)) != NULL) 
 	  l3dss1_deliver_display(proc, pr, p); /* Display IE included */
-	for (i = 0; i < DATASLLEN; i++)
+	for (i = 0; i < ARRAY_SIZE(datastatelist); i++)
 		if ((mt == datastatelist[i].primitive) &&
 		    ((1 << proc->state) & datastatelist[i].state))
 			break;
-	if (i == DATASLLEN) {
+	if (i == ARRAY_SIZE(datastatelist)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			l3_debug(st, "dss1up%sstate %d mt %#x unhandled",
 				(pr == (DL_DATA | INDICATION)) ? " " : "(broadcast) ",
@@ -3156,11 +3146,11 @@ dss1down(struct PStack *st, int pr, void *arg)
 		return;
 	}  
 
-	for (i = 0; i < DOWNSLLEN; i++)
+	for (i = 0; i < ARRAY_SIZE(downstatelist); i++)
 		if ((pr == downstatelist[i].primitive) &&
 		    ((1 << proc->state) & downstatelist[i].state))
 			break;
-	if (i == DOWNSLLEN) {
+	if (i == ARRAY_SIZE(downstatelist)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			l3_debug(st, "dss1down state %d prim %#x unhandled",
 				proc->state, pr);
@@ -3184,11 +3174,11 @@ dss1man(struct PStack *st, int pr, void *arg)
                 printk(KERN_ERR "HiSax dss1man without proc pr=%04x\n", pr);
                 return;
         }
-        for (i = 0; i < MANSLLEN; i++)
+        for (i = 0; i < ARRAY_SIZE(manstatelist); i++)
                 if ((pr == manstatelist[i].primitive) &&
                     ((1 << proc->state) & manstatelist[i].state))
                         break;
-        if (i == MANSLLEN) {
+        if (i == ARRAY_SIZE(manstatelist)) {
                 if (st->l3.debug & L3_DEB_STATE) {
                         l3_debug(st, "cr %d dss1man state %d prim %#x unhandled",
                                 proc->callref & 0x7f, proc->state, pr);
diff --git a/drivers/isdn/hisax/l3ni1.c b/drivers/isdn/hisax/l3ni1.c
index f7041d5..b6d35ee 100644
--- a/drivers/isdn/hisax/l3ni1.c
+++ b/drivers/isdn/hisax/l3ni1.c
@@ -2755,9 +2755,6 @@ static struct stateentry downstatelist[] =
 	 CC_TSPID, l3ni1_spid_tout },
 };
 
-#define DOWNSLLEN \
-	(sizeof(downstatelist) / sizeof(struct stateentry))
-
 static struct stateentry datastatelist[] =
 {
 	{ALL_STATES,
@@ -2810,9 +2807,6 @@ static struct stateentry datastatelist[] =
 	 MT_RESUME_REJECT, l3ni1_resume_rej},
 };
 
-#define DATASLLEN \
-	(sizeof(datastatelist) / sizeof(struct stateentry))
-
 static struct stateentry globalmes_list[] =
 {
 	{ALL_STATES,
@@ -2825,8 +2819,6 @@ static struct stateentry globalmes_list[] =
 	{ SBIT( 0 ), MT_DL_ESTABLISHED, l3ni1_spid_send },
 	{ SBIT( 20 ) | SBIT( 21 ) | SBIT( 22 ), MT_INFORMATION, l3ni1_spid_epid },
 };
-#define GLOBALM_LEN \
-	(sizeof(globalmes_list) / sizeof(struct stateentry))
 
 static struct stateentry manstatelist[] =
 {
@@ -2858,11 +2850,11 @@ global_handler(struct PStack *st, int mt, struct sk_buff *skb)
 		proc->callref = skb->data[2]; /* cr flag */
 	else
 		proc->callref = 0;
-	for (i = 0; i < GLOBALM_LEN; i++)
+	for (i = 0; i < ARRAY_SIZE(globalmes_list); i++)
 		if ((mt == globalmes_list[i].primitive) &&
 		    ((1 << proc->state) & globalmes_list[i].state))
 			break;
-	if (i == GLOBALM_LEN) {
+	if (i == ARRAY_SIZE(globalmes_list)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			l3_debug(st, "ni1 global state %d mt %x unhandled",
 				proc->state, mt);
@@ -3049,11 +3041,11 @@ ni1up(struct PStack *st, int pr, void *arg)
 	}
 	if ((p = findie(skb->data, skb->len, IE_DISPLAY, 0)) != NULL) 
 	  l3ni1_deliver_display(proc, pr, p); /* Display IE included */
-	for (i = 0; i < DATASLLEN; i++)
+	for (i = 0; i < ARRAY_SIZE(datastatelist); i++)
 		if ((mt == datastatelist[i].primitive) &&
 		    ((1 << proc->state) & datastatelist[i].state))
 			break;
-	if (i == DATASLLEN) {
+	if (i == ARRAY_SIZE(datastatelist)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			l3_debug(st, "ni1up%sstate %d mt %#x unhandled",
 				(pr == (DL_DATA | INDICATION)) ? " " : "(broadcast) ",
@@ -3108,11 +3100,11 @@ ni1down(struct PStack *st, int pr, void *arg)
 		return;
 	}  
 
-	for (i = 0; i < DOWNSLLEN; i++)
+	for (i = 0; i < ARRAY_SIZE(downstatelist); i++)
 		if ((pr == downstatelist[i].primitive) &&
 		    ((1 << proc->state) & downstatelist[i].state))
 			break;
-	if (i == DOWNSLLEN) {
+	if (i == ARRAY_SIZE(downstatelist)) {
 		if (st->l3.debug & L3_DEB_STATE) {
 			l3_debug(st, "ni1down state %d prim %#x unhandled",
 				proc->state, pr);
@@ -3136,11 +3128,11 @@ ni1man(struct PStack *st, int pr, void *arg)
                 printk(KERN_ERR "HiSax ni1man without proc pr=%04x\n", pr);
                 return;
         }
-        for (i = 0; i < MANSLLEN; i++)
+        for (i = 0; i < ARRAY_SIZE(manstatelist); i++)
                 if ((pr == manstatelist[i].primitive) &&
                     ((1 << proc->state) & manstatelist[i].state))
                         break;
-        if (i == MANSLLEN) {
+        if (i == ARRAY_SIZE(manstatelist)) {
                 if (st->l3.debug & L3_DEB_STATE) {
                         l3_debug(st, "cr %d ni1man state %d prim %#x unhandled",
                                 proc->callref & 0x7f, proc->state, pr);
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index aacbf0d..846c211 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -140,8 +140,6 @@ struct MessageType {
 	}
 };
 
-#define MTSIZE sizeof(mtlist)/sizeof(struct MessageType)
-
 static
 struct MessageType mt_n0[] =
 {
@@ -157,8 +155,6 @@ struct MessageType mt_n0[] =
 	{MT_N0_CLO_ACK, "CLOse ACKnowledge"}
 };
 
-#define MT_N0_LEN (sizeof(mt_n0) / sizeof(struct MessageType))
-
 static
 struct MessageType mt_n1[] =
 {
@@ -194,9 +190,6 @@ struct MessageType mt_n1[] =
 	{MT_N1_STAT, "STATus"}
 };
 
-#define MT_N1_LEN (sizeof(mt_n1) / sizeof(struct MessageType))
-
-
 static int
 prbits(char *dest, u_char b, int start, int len)
 {
@@ -438,8 +431,6 @@ struct CauseValue {
 	},
 };
 
-#define CVSIZE sizeof(cvlist)/sizeof(struct CauseValue)
-
 static
 int
 prcause(char *dest, u_char * p)
@@ -460,12 +451,12 @@ prcause(char *dest, u_char * p)
 	cause = 0x7f & *p++;
 
 	/* locate cause value */
-	for (i = 0; i < CVSIZE; i++)
+	for (i = 0; i < ARRAY_SIZE(cvlist); i++)
 		if (cvlist[i].nr == cause)
 			break;
 
 	/* display cause value if it exists */
-	if (i == CVSIZE)
+	if (i == ARRAY_SIZE(cvlist))
 		dp += sprintf(dp, "Unknown cause type %x!\n", cause);
 	else
 		dp += sprintf(dp, "  cause value %x : %s \n", cause, cvlist[i].edescr);
@@ -516,8 +507,6 @@ struct MessageType cause_1tr6[] =
 	{CAUSE_UserInfoDiscarded, "User Info Discarded"}
 };
 
-static int cause_1tr6_len = (sizeof(cause_1tr6) / sizeof(struct MessageType));
-
 static int
 prcause_1tr6(char *dest, u_char * p)
 {
@@ -539,12 +528,12 @@ prcause_1tr6(char *dest, u_char * p)
 	cause = 0x7f & *p;
 
 	/* locate cause value */
-	for (i = 0; i < cause_1tr6_len; i++)
+	for (i = 0; i < ARRAY_SIZE(cause_1tr6); i++)
 		if (cause_1tr6[i].nr == cause)
 			break;
 
 	/* display cause value if it exists */
-	if (i == cause_1tr6_len)
+	if (i == ARRAY_SIZE(cause_1tr6))
 		dp += sprintf(dp, "Unknown cause type %x!\n", cause);
 	else
 		dp += sprintf(dp, "  cause value %x : %s \n", cause, cause_1tr6[i].descr);
@@ -865,7 +854,6 @@ struct DTag { /* Display tags */
 	{ 0x96, "Redirection name" },
 	{ 0x9e, "Text" },
 };
-#define DTAGSIZE sizeof(dtaglist)/sizeof(struct DTag)
 
 static int
 disptext_ni1(char *dest, u_char * p)
@@ -887,12 +875,12 @@ disptext_ni1(char *dest, u_char * p)
 		/* Don't space or skip */
 		if ((tag == 0x80) || (tag == 0x81)) p++;
 		else {
-			for (i = 0; i < DTAGSIZE; i++)
+			for (i = 0; i < ARRAY_SIZE(dtaglist); i++)
 				if (tag == dtaglist[i].nr)
 					break;
 
 			/* When not found, give appropriate msg */
-			if (i != DTAGSIZE) {
+			if (i != ARRAY_SIZE(dtaglist)) {
 				dp += sprintf(dp, "    %s: ", dtaglist[i].descr);
 				while (len--)
 					*dp++ = *p++;
@@ -1073,9 +1061,6 @@ struct InformationElement {
 	},
 };
 
-
-#define IESIZE sizeof(ielist)/sizeof(struct InformationElement)
-
 static
 struct InformationElement ielist_ni1[] = {
 	{ 0x04, "Bearer Capability", prbearer_ni1 },
@@ -1101,24 +1086,17 @@ struct InformationElement ielist_ni1[] = {
 	{ 0x7d, "High Layer Compatibility", general_ni1 },
 };
 
-
-#define IESIZE_NI1 sizeof(ielist_ni1)/sizeof(struct InformationElement)
-
 static
 struct InformationElement ielist_ni1_cs5[] = {
 	{ 0x1d, "Operator system access", general_ni1 },
 	{ 0x2a, "Display text", disptext_ni1 },
 };
 
-#define IESIZE_NI1_CS5 sizeof(ielist_ni1_cs5)/sizeof(struct InformationElement)
-
 static
 struct InformationElement ielist_ni1_cs6[] = {
 	{ 0x7b, "Call appearance", general_ni1 },
 };
 
-#define IESIZE_NI1_CS6 sizeof(ielist_ni1_cs6)/sizeof(struct InformationElement)
-
 static struct InformationElement we_0[] =
 {
 	{WE0_cause, "Cause", prcause_1tr6},
@@ -1133,8 +1111,6 @@ static struct InformationElement we_0[] =
 	{WE0_userInfo, "User Info", general}
 };
 
-#define WE_0_LEN (sizeof(we_0) / sizeof(struct InformationElement))
-
 static struct InformationElement we_6[] =
 {
 	{WE6_serviceInd, "Service Indicator", general},
@@ -1145,7 +1121,6 @@ static struct InformationElement we_6[] =
 	{WE6_statusCalled, "Status Called", general},
 	{WE6_addTransAttr, "Additional Transmission Attributes", general}
 };
-#define WE_6_LEN (sizeof(we_6) / sizeof(struct InformationElement))
 
 int
 QuickHex(char *txt, u_char * p, int cnt)
@@ -1268,11 +1243,11 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 			cr = 0;
 		mt = *buf++;
 		if (pd == PROTO_DIS_N0) {	/* N0 */
-			for (i = 0; i < MT_N0_LEN; i++)
+			for (i = 0; i < ARRAY_SIZE(mt_n0); i++)
 				if (mt_n0[i].nr == mt)
 					break;
 			/* display message type if it exists */
-			if (i == MT_N0_LEN)
+			if (i == ARRAY_SIZE(mt_n0))
 				dp += sprintf(dp, "callref %d %s size %d unknown message type N0 %x!\n",
 					      cr & 0x7f, (cr & 0x80) ? "called" : "caller",
 					      size, mt);
@@ -1281,11 +1256,11 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 					      cr & 0x7f, (cr & 0x80) ? "called" : "caller",
 					      size, mt_n0[i].descr);
 		} else {	/* N1 */
-			for (i = 0; i < MT_N1_LEN; i++)
+			for (i = 0; i < ARRAY_SIZE(mt_n1); i++)
 				if (mt_n1[i].nr == mt)
 					break;
 			/* display message type if it exists */
-			if (i == MT_N1_LEN)
+			if (i == ARRAY_SIZE(mt_n1))
 				dp += sprintf(dp, "callref %d %s size %d unknown message type N1 %x!\n",
 					      cr & 0x7f, (cr & 0x80) ? "called" : "caller",
 					      size, mt);
@@ -1328,23 +1303,23 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 			}
 			/* No, locate it in the table */
 			if (cset == 0) {
-				for (i = 0; i < WE_0_LEN; i++)
+				for (i = 0; i < ARRAY_SIZE(we_0); i++)
 					if (*buf == we_0[i].nr)
 						break;
 
 				/* When found, give appropriate msg */
-				if (i != WE_0_LEN) {
+				if (i != ARRAY_SIZE(we_0)) {
 					dp += sprintf(dp, "  %s\n", we_0[i].descr);
 					dp += we_0[i].f(dp, buf);
 				} else
 					dp += sprintf(dp, "  Codeset %d attribute %x attribute size %d\n", cset, *buf, buf[1]);
 			} else if (cset == 6) {
-				for (i = 0; i < WE_6_LEN; i++)
+				for (i = 0; i < ARRAY_SIZE(we_6); i++)
 					if (*buf == we_6[i].nr)
 						break;
 
 				/* When found, give appropriate msg */
-				if (i != WE_6_LEN) {
+				if (i != ARRAY_SIZE(we_6)) {
 					dp += sprintf(dp, "  %s\n", we_6[i].descr);
 					dp += we_6[i].f(dp, buf);
 				} else
@@ -1368,12 +1343,12 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 		else
 			cr = 0;
 		mt = *buf++;
-		for (i = 0; i < MTSIZE; i++)
+		for (i = 0; i < ARRAY_SIZE(mtlist); i++)
 			if (mtlist[i].nr == mt)
 				break;
 
 		/* display message type if it exists */
-		if (i == MTSIZE)
+		if (i == ARRAY_SIZE(mtlist))
 			dp += sprintf(dp, "callref %d %s size %d unknown message type %x!\n",
 			    cr & 0x7f, (cr & 0x80) ? "called" : "caller",
 				      size, mt);
@@ -1402,34 +1377,34 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 			}
 			/* No, locate it in the table */
 			if (cset == 0) {
-				for (i = 0; i < IESIZE_NI1; i++)
+				for (i = 0; i < ARRAY_SIZE(ielist_ni1); i++)
 					if (*buf == ielist_ni1[i].nr)
 						break;
 
 				/* When not found, give appropriate msg */
-				if (i != IESIZE_NI1) {
+				if (i != ARRAY_SIZE(ielist_ni1)) {
 					dp += sprintf(dp, "  %s\n", ielist_ni1[i].descr);
 					dp += ielist_ni1[i].f(dp, buf);
 				} else
 					dp += sprintf(dp, "  attribute %x attribute size %d\n", *buf, buf[1]);
 			} else if (cset == 5) {
-				for (i = 0; i < IESIZE_NI1_CS5; i++)
+				for (i = 0; i < ARRAY_SIZE(ielist_ni1_cs5); i++)
 					if (*buf == ielist_ni1_cs5[i].nr)
 						break;
 
 				/* When not found, give appropriate msg */
-				if (i != IESIZE_NI1_CS5) {
+				if (i != ARRAY_SIZE(ielist_ni1_cs5)) {
 					dp += sprintf(dp, "  %s\n", ielist_ni1_cs5[i].descr);
 					dp += ielist_ni1_cs5[i].f(dp, buf);
 				} else
 					dp += sprintf(dp, "  attribute %x attribute size %d\n", *buf, buf[1]);
 			} else if (cset == 6) {
-				for (i = 0; i < IESIZE_NI1_CS6; i++)
+				for (i = 0; i < ARRAY_SIZE(ielist_ni1_cs6); i++)
 					if (*buf == ielist_ni1_cs6[i].nr)
 						break;
 
 				/* When not found, give appropriate msg */
-				if (i != IESIZE_NI1_CS6) {
+				if (i != ARRAY_SIZE(ielist_ni1_cs6)) {
 					dp += sprintf(dp, "  %s\n", ielist_ni1_cs6[i].descr);
 					dp += ielist_ni1_cs6[i].f(dp, buf);
 				} else
@@ -1454,12 +1429,12 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 		else
 			cr = 0;
 		mt = *buf++;
-		for (i = 0; i < MTSIZE; i++)
+		for (i = 0; i < ARRAY_SIZE(mtlist); i++)
 			if (mtlist[i].nr == mt)
 				break;
 
 		/* display message type if it exists */
-		if (i == MTSIZE)
+		if (i == ARRAY_SIZE(mtlist))
 			dp += sprintf(dp, "callref %d %s size %d unknown message type %x!\n",
 			    cr & 0x7f, (cr & 0x80) ? "called" : "caller",
 				      size, mt);
@@ -1500,12 +1475,12 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 				continue;
 			}
 			/* No, locate it in the table */
-			for (i = 0; i < IESIZE; i++)
+			for (i = 0; i < ARRAY_SIZE(ielist); i++)
 				if (*buf == ielist[i].nr)
 					break;
 
 			/* When not found, give appropriate msg */
-			if (i != IESIZE) {
+			if (i != ARRAY_SIZE(ielist)) {
 				dp += sprintf(dp, "  %s\n", ielist[i].descr);
 				dp += ielist[i].f(dp, buf);
 			} else
diff --git a/drivers/isdn/hisax/tei.c b/drivers/isdn/hisax/tei.c
index ceb0df9..6e65424 100644
--- a/drivers/isdn/hisax/tei.c
+++ b/drivers/isdn/hisax/tei.c
@@ -447,8 +447,6 @@ static struct FsmNode TeiFnList[] __initdata =
 	{ST_TEI_IDVERIFY, EV_CHKREQ, tei_id_chk_req},
 };
 
-#define TEI_FN_COUNT (sizeof(TeiFnList)/sizeof(struct FsmNode))
-
 int __init
 TeiNew(void)
 {
@@ -456,7 +454,7 @@ TeiNew(void)
 	teifsm.event_count = TEI_EVENT_COUNT;
 	teifsm.strEvent = strTeiEvent;
 	teifsm.strState = strTeiState;
-	return FsmNew(&teifsm, TeiFnList, TEI_FN_COUNT);
+	return FsmNew(&teifsm, TeiFnList, ARRAY_SIZE(TeiFnList));
 }
 
 void

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
