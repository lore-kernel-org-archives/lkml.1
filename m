Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXFJNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXFJNLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXFJNL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:11:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:35584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbXFJNLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:11:25 -0400
Date: Sun, 10 Jun 2007 15:11:22 +0200
From: Karsten Keil <kkeil@suse.de>
To: Andi Drebes <lists-receive@programmierforen.de>
Cc: kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Message-ID: <20070610131122.GB3588@pingi.kke.suse.de>
Mail-Followup-To: Andi Drebes <lists-receive@programmierforen.de>,
	kernel-janitors@lists.osdl.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200706101235.09578.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706101235.09578.lists-receive@programmierforen.de>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is OK, thanks for changing.

On Sun, Jun 10, 2007 at 12:35:08PM +0200, Andi Drebes wrote:
> This patch replaces various array size calculations in drivers/isdn/hisax
> done using sizeof with the ARRAY_SIZE macro.
> 
> Please CC me when you write comments, because I'm not subscribed
> to the LKML.
> 
> Tested by compilation on an i386 box using "allyesconfig".
> Diffed against Linus' git-tree.
> 
> Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
> ---
> diff --git a/drivers/isdn/hisax/callc.c b/drivers/isdn/hisax/callc.c
> index 7c56c44..50b98d5 100644
> --- a/drivers/isdn/hisax/callc.c
> +++ b/drivers/isdn/hisax/callc.c
> @@ -834,7 +834,7 @@ static struct FsmNode fnlist[] __initdata =
>  };
>  /* *INDENT-ON* */
>  
> -#define FNCOUNT (sizeof(fnlist)/sizeof(struct FsmNode))
> +#define FNCOUNT ARRAY_SIZE(fnlist)
>  
>  int __init
>  CallcNew(void)
> diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
> index a14204e..39c749c 100644
> --- a/drivers/isdn/hisax/isdnl1.c
> +++ b/drivers/isdn/hisax/isdnl1.c
> @@ -647,7 +647,7 @@ static struct FsmNode L1SFnList[] __initdata =
>  	{ST_L1_F8, EV_TIMER_DEACT, l1_timer_deact},
>  };
>  
> -#define L1S_FN_COUNT (sizeof(L1SFnList)/sizeof(struct FsmNode))
> +#define L1S_FN_COUNT ARRAY_SIZE(L1SFnList)
>  
>  #ifdef HISAX_UINTERFACE
>  static void
> @@ -706,7 +706,7 @@ static struct FsmNode L1UFnList[] __initdata =
>  	{ST_L1_RESET, EV_TIMER_DEACT, l1_timer_deact},
>  };
>  
> -#define L1U_FN_COUNT (sizeof(L1UFnList)/sizeof(struct FsmNode))
> +#define L1U_FN_COUNT ARRAY_SIZE(L1UFnList)
>  
>  #endif
>  
> @@ -754,7 +754,7 @@ static struct FsmNode L1BFnList[] __initdata =
>  	{ST_L1_WAIT_DEACT, EV_TIMER_DEACT, l1b_timer_deact},
>  };
>  
> -#define L1B_FN_COUNT (sizeof(L1BFnList)/sizeof(struct FsmNode))
> +#define L1B_FN_COUNT ARRAY_SIZE(L1BFnList)
>  
>  int __init 
>  Isdnl1New(void)
> diff --git a/drivers/isdn/hisax/isdnl2.c b/drivers/isdn/hisax/isdnl2.c
> index 3446f24..846a7e6 100644
> --- a/drivers/isdn/hisax/isdnl2.c
> +++ b/drivers/isdn/hisax/isdnl2.c
> @@ -1623,7 +1623,7 @@ static struct FsmNode L2FnList[] __initdata =
>  	{ST_L2_8, EV_L1_DEACTIVATE, l2_persistent_da},
>  };
>  
> -#define L2_FN_COUNT (sizeof(L2FnList)/sizeof(struct FsmNode))
> +#define L2_FN_COUNT ARRAY_SIZE(L2FnList)
>  
>  static void
>  isdnl2_l1l2(struct PStack *st, int pr, void *arg)
> diff --git a/drivers/isdn/hisax/isdnl3.c b/drivers/isdn/hisax/isdnl3.c
> index 935f233..c081fed 100644
> --- a/drivers/isdn/hisax/isdnl3.c
> +++ b/drivers/isdn/hisax/isdnl3.c
> @@ -543,7 +543,7 @@ static struct FsmNode L3FnList[] __initdata =
>  };
>  /* *INDENT-ON* */
>  
> -#define L3_FN_COUNT (sizeof(L3FnList)/sizeof(struct FsmNode))
> +#define L3_FN_COUNT ARRAY_SIZE(L3FnList)
>  
>  void
>  l3_msg(struct PStack *st, int pr, void *arg)
> diff --git a/drivers/isdn/hisax/l3_1tr6.c b/drivers/isdn/hisax/l3_1tr6.c
> index c5c36ee..ff62679 100644
> --- a/drivers/isdn/hisax/l3_1tr6.c
> +++ b/drivers/isdn/hisax/l3_1tr6.c
> @@ -698,8 +698,7 @@ static struct stateentry downstl[] =
>  	 CC_T308_2, l3_1tr6_t308_2},
>  };
>  
> -#define DOWNSTL_LEN \
> -	(sizeof(downstl) / sizeof(struct stateentry))
> +#define DOWNSTL_LEN ARRAY_SIZE(downstl)
>  
>  static struct stateentry datastln1[] =
>  {
> @@ -735,8 +734,7 @@ static struct stateentry datastln1[] =
>  	 MT_N1_REL_ACK, l3_1tr6_rel_ack}
>  };
>  
> -#define DATASTLN1_LEN \
> -	(sizeof(datastln1) / sizeof(struct stateentry))
> +#define DATASTLN1_LEN ARRAY_SIZE(datastln1)
>  
>  static struct stateentry manstatelist[] =
>  {
> @@ -746,8 +744,7 @@ static struct stateentry manstatelist[] =
>           DL_RELEASE | INDICATION, l3_1tr6_dl_release},
>  };
>   
> -#define MANSLLEN \
> -        (sizeof(manstatelist) / sizeof(struct stateentry))
> +#define MANSLLEN ARRAY_SIZE(manstatelist)
>  /* *INDENT-ON* */
>  
>  static void
> diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
> index 99feae8..c434fa5 100644
> --- a/drivers/isdn/hisax/l3dss1.c
> +++ b/drivers/isdn/hisax/l3dss1.c
> @@ -2820,8 +2820,7 @@ static struct stateentry downstatelist[] =
>  	 CC_T309, l3dss1_dl_release},
>  };
>  
> -#define DOWNSLLEN \
> -	(sizeof(downstatelist) / sizeof(struct stateentry))
> +#define DOWNSLLEN ARRAY_SIZE(downstatelist)
>  
>  static struct stateentry datastatelist[] =
>  {
> @@ -2875,8 +2874,7 @@ static struct stateentry datastatelist[] =
>  	 MT_RESUME_REJECT, l3dss1_resume_rej},
>  };
>  
> -#define DATASLLEN \
> -	(sizeof(datastatelist) / sizeof(struct stateentry))
> +#define DATASLLEN ARRAY_SIZE(datastatelist)
>  
>  static struct stateentry globalmes_list[] =
>  {
> @@ -2888,8 +2886,7 @@ static struct stateentry globalmes_list[] =
>  	 MT_RESTART_ACKNOWLEDGE, l3dss1_restart_ack},
>  */
>  };
> -#define GLOBALM_LEN \
> -	(sizeof(globalmes_list) / sizeof(struct stateentry))
> +#define GLOBALM_LEN ARRAY_SIZE(globalmes_list)
>  
>  static struct stateentry manstatelist[] =
>  {
> @@ -2903,8 +2900,7 @@ static struct stateentry manstatelist[] =
>           DL_RELEASE | INDICATION, l3dss1_dl_release},
>  };
>  
> -#define MANSLLEN \
> -        (sizeof(manstatelist) / sizeof(struct stateentry))
> +#define MANSLLEN ARRAY_SIZE(manstatelist)
>  /* *INDENT-ON* */
>  
>  
> diff --git a/drivers/isdn/hisax/l3ni1.c b/drivers/isdn/hisax/l3ni1.c
> index f7041d5..ba05ae3 100644
> --- a/drivers/isdn/hisax/l3ni1.c
> +++ b/drivers/isdn/hisax/l3ni1.c
> @@ -2755,8 +2755,7 @@ static struct stateentry downstatelist[] =
>  	 CC_TSPID, l3ni1_spid_tout },
>  };
>  
> -#define DOWNSLLEN \
> -	(sizeof(downstatelist) / sizeof(struct stateentry))
> +#define DOWNSLLEN ARRAY_SIZE(downstatelist)
>  
>  static struct stateentry datastatelist[] =
>  {
> @@ -2810,8 +2809,7 @@ static struct stateentry datastatelist[] =
>  	 MT_RESUME_REJECT, l3ni1_resume_rej},
>  };
>  
> -#define DATASLLEN \
> -	(sizeof(datastatelist) / sizeof(struct stateentry))
> +#define DATASLLEN ARRAY_SIZE(datastatelist)
>  
>  static struct stateentry globalmes_list[] =
>  {
> @@ -2825,8 +2823,7 @@ static struct stateentry globalmes_list[] =
>  	{ SBIT( 0 ), MT_DL_ESTABLISHED, l3ni1_spid_send },
>  	{ SBIT( 20 ) | SBIT( 21 ) | SBIT( 22 ), MT_INFORMATION, l3ni1_spid_epid },
>  };
> -#define GLOBALM_LEN \
> -	(sizeof(globalmes_list) / sizeof(struct stateentry))
> +#define GLOBALM_LEN ARRAY_SIZE(globalmes_list)
>  
>  static struct stateentry manstatelist[] =
>  {
> @@ -2840,8 +2837,7 @@ static struct stateentry manstatelist[] =
>           DL_RELEASE | INDICATION, l3ni1_dl_release},
>  };
>  
> -#define MANSLLEN \
> -        (sizeof(manstatelist) / sizeof(struct stateentry))
> +#define MANSLLEN ARRAY_SIZE(manstatelist)
>  /* *INDENT-ON* */
>  
>  
> diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
> index aacbf0d..8b853d5 100644
> --- a/drivers/isdn/hisax/q931.c
> +++ b/drivers/isdn/hisax/q931.c
> @@ -140,7 +140,7 @@ struct MessageType {
>  	}
>  };
>  
> -#define MTSIZE sizeof(mtlist)/sizeof(struct MessageType)
> +#define MTSIZE ARRAY_SIZE(mtlist)
>  
>  static
>  struct MessageType mt_n0[] =
> @@ -157,7 +157,7 @@ struct MessageType mt_n0[] =
>  	{MT_N0_CLO_ACK, "CLOse ACKnowledge"}
>  };
>  
> -#define MT_N0_LEN (sizeof(mt_n0) / sizeof(struct MessageType))
> +#define MT_N0_LEN ARRAY_SIZE(mt_n0)
>  
>  static
>  struct MessageType mt_n1[] =
> @@ -194,7 +194,7 @@ struct MessageType mt_n1[] =
>  	{MT_N1_STAT, "STATus"}
>  };
>  
> -#define MT_N1_LEN (sizeof(mt_n1) / sizeof(struct MessageType))
> +#define MT_N1_LEN ARRAY_SIZE(mt_n1)
>  
>  
>  static int
> @@ -438,7 +438,7 @@ struct CauseValue {
>  	},
>  };
>  
> -#define CVSIZE sizeof(cvlist)/sizeof(struct CauseValue)
> +#define CVSIZE ARRAY_SIZE(cvlist)
>  
>  static
>  int
> @@ -516,7 +516,7 @@ struct MessageType cause_1tr6[] =
>  	{CAUSE_UserInfoDiscarded, "User Info Discarded"}
>  };
>  
> -static int cause_1tr6_len = (sizeof(cause_1tr6) / sizeof(struct MessageType));
> +static int cause_1tr6_len = ARRAY_SIZE(cause_1tr6);
>  
>  static int
>  prcause_1tr6(char *dest, u_char * p)
> @@ -865,7 +865,7 @@ struct DTag { /* Display tags */
>  	{ 0x96, "Redirection name" },
>  	{ 0x9e, "Text" },
>  };
> -#define DTAGSIZE sizeof(dtaglist)/sizeof(struct DTag)
> +#define DTAGSIZE ARRAY_SIZE(dtaglist)
>  
>  static int
>  disptext_ni1(char *dest, u_char * p)
> @@ -1074,7 +1074,7 @@ struct InformationElement {
>  };
>  
>  
> -#define IESIZE sizeof(ielist)/sizeof(struct InformationElement)
> +#define IESIZE ARRAY_SIZE(ielist)
>  
>  static
>  struct InformationElement ielist_ni1[] = {
> @@ -1102,7 +1102,7 @@ struct InformationElement ielist_ni1[] = {
>  };
>  
>  
> -#define IESIZE_NI1 sizeof(ielist_ni1)/sizeof(struct InformationElement)
> +#define IESIZE_NI1 ARRAY_SIZE(ielist_ni1)
>  
>  static
>  struct InformationElement ielist_ni1_cs5[] = {
> @@ -1110,14 +1110,14 @@ struct InformationElement ielist_ni1_cs5[] = {
>  	{ 0x2a, "Display text", disptext_ni1 },
>  };
>  
> -#define IESIZE_NI1_CS5 sizeof(ielist_ni1_cs5)/sizeof(struct InformationElement)
> +#define IESIZE_NI1_CS5 ARRAY_SIZE(ielist_ni1_cs5)
>  
>  static
>  struct InformationElement ielist_ni1_cs6[] = {
>  	{ 0x7b, "Call appearance", general_ni1 },
>  };
>  
> -#define IESIZE_NI1_CS6 sizeof(ielist_ni1_cs6)/sizeof(struct InformationElement)
> +#define IESIZE_NI1_CS6 ARRAY_SIZE(ielist_ni1_cs6)
>  
>  static struct InformationElement we_0[] =
>  {
> @@ -1133,7 +1133,7 @@ static struct InformationElement we_0[] =
>  	{WE0_userInfo, "User Info", general}
>  };
>  
> -#define WE_0_LEN (sizeof(we_0) / sizeof(struct InformationElement))
> +#define WE_0_LEN ARRAY_SIZE(we_0)
>  
>  static struct InformationElement we_6[] =
>  {
> @@ -1145,7 +1145,7 @@ static struct InformationElement we_6[] =
>  	{WE6_statusCalled, "Status Called", general},
>  	{WE6_addTransAttr, "Additional Transmission Attributes", general}
>  };
> -#define WE_6_LEN (sizeof(we_6) / sizeof(struct InformationElement))
> +#define WE_6_LEN ARRAY_SIZE(we_6)
>  
>  int
>  QuickHex(char *txt, u_char * p, int cnt)
> diff --git a/drivers/isdn/hisax/tei.c b/drivers/isdn/hisax/tei.c
> index ceb0df9..21567af 100644
> --- a/drivers/isdn/hisax/tei.c
> +++ b/drivers/isdn/hisax/tei.c
> @@ -447,7 +447,7 @@ static struct FsmNode TeiFnList[] __initdata =
>  	{ST_TEI_IDVERIFY, EV_CHKREQ, tei_id_chk_req},
>  };
>  
> -#define TEI_FN_COUNT (sizeof(TeiFnList)/sizeof(struct FsmNode))
> +#define TEI_FN_COUNT ARRAY_SIZE(TeiFnList)
>  
>  int __init
>  TeiNew(void)

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
